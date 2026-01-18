#!/usr/bin/env python3
"""
massive_file_runner_fixed.py
Fixed version for massive files (68,000+ lines)
Handles EOT/EOF properly and checks directory structure
Now also skips Flutter commands
"""

import os
import sys
import re
import time
import subprocess
from pathlib import Path

class FixedMassiveFileRunner:
    def __init__(self, input_file, batch_size=1000):
        self.input_file = input_file
        self.batch_size = batch_size
        self.total_lines = 0
        self.total_commands = 0
        self.bash_commands = []
        
        # قائمة أوامر Flutter التي يجب تخطيها
        self.flutter_commands_to_skip = [
            'flutter run',
            'flutter get pub',
            'flutter clean',
            'flutter pub get',
            'flutter pub upgrade',
            'flutter build',
            'flutter test'
        ]
        
    def count_lines(self):
        """Count file lines quickly"""
        print("📊 Counting file lines...")
        with open(self.input_file, 'r', encoding='utf-8') as f:
            for i, _ in enumerate(f, 1):
                pass
        self.total_lines = i
        print(f"  Total lines: {self.total_lines:,}")
        return self.total_lines
    
    def is_flutter_command(self, line):
        """Check if line contains Flutter commands to skip"""
        line_lower = line.lower()
        for flutter_cmd in self.flutter_commands_to_skip:
            if flutter_cmd in line_lower:
                return True
        return False
    
    def extract_bash_commands_fixed(self):
        """Extract ONLY valid bash commands - FIXED VERSION"""
        print("🔍 Extracting bash commands (fixed version)...")
        print(f"🚫 Skipping Flutter commands: {', '.join(self.flutter_commands_to_skip[:3])}...")
        
        self.bash_commands = []
        in_heredoc = False
        heredoc_marker = ""
        current_command = []
        command_count = 0
        skipped_commands = 0
        
        with open(self.input_file, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                line = line.rstrip('\n')
                
                # Check for Flutter commands (skip them)
                if self.is_flutter_command(line):
                    skipped_commands += 1
                    if skipped_commands <= 5:  # Show first 5 skipped commands
                        print(f"  ⏭️ Skipping Flutter command at line {line_num}: {line[:80]}...")
                    continue
                
                # Skip comments outside heredoc
                if line.strip().startswith('//') and not in_heredoc:
                    continue
                
                # Skip Gradle/Kotlin code outside heredoc
                if (re.match(r'^\s*implementation\(', line) or
                    re.match(r'^\s*class\s', line) or
                    re.match(r'^\s*package\s', line)) and not in_heredoc:
                    continue
                
                # Start of heredoc block (cat > file << 'EOT')
                if not in_heredoc and 'cat >' in line and '<<' in line:
                    match = re.search(r'<<\s*[\'"]?(EOT|EOF)[\'"]?', line)
                    if match:
                        in_heredoc = True
                        heredoc_marker = match.group(1)
                        # Start new command group
                        current_command = [line]
                    continue
                
                # Inside heredoc
                if in_heredoc:
                    current_command.append(line)
                    # Check for end marker
                    if line.strip() == heredoc_marker:
                        in_heredoc = False
                        full_command = '\n'.join(current_command)
                        
                        # Check if heredoc contains Flutter commands
                        if not self.is_flutter_command(full_command):
                            self.bash_commands.append(full_command)
                            command_count += 1
                        else:
                            skipped_commands += 1
                            if skipped_commands <= 5:
                                print(f"  ⏭️ Skipping heredoc with Flutter at line {line_num}")
                        
                        current_command = []
                    continue
                
                # mkdir commands - only add if not Flutter related
                if line.strip().startswith('mkdir '):
                    if not self.is_flutter_command(line):
                        self.bash_commands.append(line)
                        command_count += 1
                    else:
                        skipped_commands += 1
                        if skipped_commands <= 5:
                            print(f"  ⏭️ Skipping mkdir Flutter at line {line_num}: {line[:80]}...")
                
                # IMPORTANT: Do NOT add standalone EOT/EOF - they should only appear inside heredoc blocks
                # Skip these lines
        
        self.total_commands = command_count
        print(f"✅ Extracted {self.total_commands:,} bash commands")
        print(f"⏭️ Skipped {skipped_commands:,} Flutter-related commands")
        
        # Debug: Show first few commands
        if self.bash_commands:
            print("\n📋 First 5 commands preview:")
            for i, cmd in enumerate(self.bash_commands[:5], 1):
                print(f"{i}: {cmd[:100]}..." if len(cmd) > 100 else f"{i}: {cmd}")
        else:
            print("⚠️ No bash commands found after filtering")
        
        return self.bash_commands
    
    def filter_commands_by_type(self, required_types=None):
        """
        Filter commands by required types (mkdir, cat, etc.)
        Args:
            required_types: List of command types to keep (e.g., ['mkdir', 'cat'])
        """
        if not required_types:
            return self.bash_commands
        
        filtered_commands = []
        for cmd in self.bash_commands:
            cmd_lower = cmd.lower()
            keep = False
            
            # Check if command contains any required type
            for req_type in required_types:
                if req_type in cmd_lower:
                    keep = True
                    break
            
            # Special handling for mkdir commands
            if 'mkdir' in required_types and cmd.strip().startswith('mkdir '):
                keep = True
            
            if keep:
                filtered_commands.append(cmd)
        
        print(f"🔍 Filtered to {len(filtered_commands)} commands containing: {required_types}")
        return filtered_commands
    
    def extract_terminal_commands_only(self):
        """
        Extract ONLY terminal commands (mkdir, cat, eqf, sed, sid)
        and exclude Flutter commands
        """
        terminal_commands = ['mkdir', 'cat', 'eqf', 'sed', 'sid']
        print(f"🔍 Extracting terminal commands only: {terminal_commands}")
        
        terminal_only = []
        skipped_not_terminal = 0
        
        for cmd in self.bash_commands:
            cmd_lower = cmd.lower()
            is_terminal = False
            
            # Check if contains terminal command
            for term_cmd in terminal_commands:
                if term_cmd in cmd_lower:
                    is_terminal = True
                    break
            
            if is_terminal:
                terminal_only.append(cmd)
            else:
                skipped_not_terminal += 1
        
        print(f"✅ Found {len(terminal_only)} terminal commands")
        print(f"⏭️ Skipped {skipped_not_terminal} non-terminal commands")
        
        # Update the commands list
        self.bash_commands = terminal_only
        self.total_commands = len(terminal_only)
        
        return terminal_only
    
    def create_batches_fixed(self):
        """Create batches with directory creation first"""
        if not self.bash_commands:
            print("⚠️ No commands to batch")
            return []
        
        # Separate mkdir commands from file creation commands
        mkdir_commands = []
        other_commands = []
        
        for cmd in self.bash_commands:
            if cmd.strip().startswith('mkdir '):
                mkdir_commands.append(cmd)
            else:
                other_commands.append(cmd)
        
        print(f"📊 Command types after filtering:")
        print(f"  - mkdir commands: {len(mkdir_commands)}")
        print(f"  - file commands: {len(other_commands)}")
        
        # Create batches: all mkdir first, then others
        batches = []
        
        # Batch 1: All mkdir commands
        if mkdir_commands:
            batches.append(mkdir_commands)
        
        # Other commands in batches
        for i in range(0, len(other_commands), self.batch_size):
            batch = other_commands[i:i + self.batch_size]
            batches.append(batch)
        
        print(f"📦 Created {len(batches)} batches")
        return batches
    
    def create_batch_scripts_fixed(self, batches):
        """Create batch scripts with error handling"""
        os.makedirs('batch_scripts_fixed', exist_ok=True)
        script_paths = []
        
        for i, batch in enumerate(batches, 1):
            script_name = f'batch_scripts_fixed/batch_{i:03d}.sh'
            
            with open(script_name, 'w', encoding='utf-8') as f:
                f.write("#!/bin/bash\n")
                f.write(f"# Batch {i} of {len(batches)}\n")
                f.write(f"# Commands: {len(batch)} (Flutter commands filtered out)\n")
                f.write("set -e  # Stop on error\n")
                f.write("\n")
                f.write(f'echo "🚀 Batch {i}/{len(batches)} - {len(batch)} commands (No Flutter)"\n')
                f.write("date\n")
                f.write("\n")
                
                # Add mkdir -p for all directories first
                if i == 1 and batch and batch[0].startswith('mkdir '):
                    f.write("# Create all directories first\n")
                    for cmd in batch:
                        # Convert mkdir to mkdir -p for safety
                        if cmd.startswith('mkdir '):
                            f.write(cmd.replace('mkdir ', 'mkdir -p ') + '\n')
                    f.write("\necho '✅ All directories created'\n")
                    f.write("\n")
                else:
                    # For file creation batches
                    f.write("# Create files (Flutter-free)\n")
                    for cmd in batch:
                        f.write(cmd + '\n')
                
                f.write("\n")
                f.write(f'echo "✅ Batch {i} completed (No Flutter commands)"\n')
                f.write("date\n")
            
            os.chmod(script_name, 0o755)
            script_paths.append(script_name)
        
        print(f"✅ Created {len(script_paths)} batch scripts (Flutter filtered)")
        return script_paths
    
    def check_directories_exist(self):
        """Check if required parent directories exist before running"""
        print("\n🔍 Checking directory structure...")
        
        missing_dirs = []
        
        for cmd in self.bash_commands:
            if cmd.startswith('cat >'):
                # Extract filename from cat command
                match = re.match(r'cat\s+>\s*([^\s<]+)', cmd)
                if match:
                    filename = match.group(1)
                    # Get directory part
                    dir_path = os.path.dirname(filename)
                    if dir_path and not os.path.exists(dir_path):
                        missing_dirs.append(dir_path)
        
        if missing_dirs:
            print("⚠️ Missing directories detected:")
            unique_dirs = list(set(missing_dirs))[:10]  # Show first 10
            for d in unique_dirs:
                print(f"  - {d}")
            
            if len(missing_dirs) > 10:
                print(f"  ... and {len(missing_dirs) - 10} more")
            
            # Create missing directories
            response = input("\nCreate missing directories? (y/n): ")
            if response.lower() == 'y':
                for d in set(missing_dirs):
                    os.makedirs(d, exist_ok=True)
                    print(f"  Created: {d}")
        
        return len(missing_dirs) == 0
    
    def create_optimized_single_script(self):
        """Create a single optimized script that handles everything"""
        script_name = "optimized_run_all_no_flutter.sh"
        
        print(f"\n🔨 Creating optimized single script (No Flutter)...")
        
        with open(script_name, 'w', encoding='utf-8') as f:
            f.write("#!/bin/bash\n")
            f.write("# Optimized script for massive file execution - NO FLUTTER\n")
            f.write("# Auto-generated with error handling\n")
            f.write("\n")
            f.write("set -e  # Stop on error\n")
            f.write("set -x  # Print commands\n")
            f.write("\n")
            f.write('echo "=========================================="\n')
            f.write('echo "🚀 STARTING OPTIMIZED EXECUTION (NO FLUTTER)"\n')
            f.write('echo "=========================================="\n')
            f.write("date\n")
            f.write("\n")
            
            # Phase 1: Extract and create all directories first
            f.write("# PHASE 1: Create all directories\n")
            f.write('echo "--- Phase 1: Creating directories ---"\n')
            f.write("\n")
            
            dirs_created = set()
            for cmd in self.bash_commands:
                if cmd.startswith('mkdir '):
                    # Extract directory path
                    match = re.match(r'mkdir\s+(?:-p\s+)?["\']?([^"\'\s]+)["\']?', cmd)
                    if match:
                        dir_path = match.group(1)
                        if dir_path not in dirs_created:
                            f.write(f"mkdir -p '{dir_path}'\n")
                            dirs_created.add(dir_path)
            
            f.write('echo "✅ Phase 1 complete: Directories created"\n')
            f.write("\n")
            
            # Phase 2: Create all files (Flutter-free)
            f.write("# PHASE 2: Create all files (NO FLUTTER)\n")
            f.write('echo "--- Phase 2: Creating files ---"\n')
            f.write("\n")
            
            file_count = 0
            for cmd in self.bash_commands:
                if not cmd.startswith('mkdir '):
                    f.write(cmd + '\n')
                    file_count += 1
            
            f.write("\n")
            f.write(f'echo "✅ Phase 2 complete: {file_count} files created (No Flutter)"\n')
            f.write("\n")
            f.write('echo "=========================================="\n')
            f.write('echo "🎉 ALL COMMANDS EXECUTED SUCCESSFULLY"\n')
            f.write(f'echo "Total commands: {self.total_commands:,}"\n')
            f.write(f'echo "Flutter commands: Filtered out"\n')
            f.write('echo "=========================================="\n')
            f.write("date\n")
        
        os.chmod(script_name, 0o755)
        
        print(f"✅ Created: {script_name}")
        print(f"📏 Lines in script: {sum(1 for line in open(script_name))}")
        
        return script_name
    
    def run_script_with_error_handling(self, script_path):
        """Run script with better error handling"""
        print(f"\n🚀 Running: {os.path.basename(script_path)}")
        print("-" * 60)
        
        start_time = time.time()
        
        try:
            # Run with bash -x to see commands
            process = subprocess.Popen(
                ['bash', '-x', script_path],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=1,
                universal_newlines=True
            )
            
            # Read output in real-time
            output_lines = []
            while True:
                stdout_line = process.stdout.readline()
                stderr_line = process.stderr.readline()
                
                if not stdout_line and not stderr_line and process.poll() is not None:
                    break
                
                if stdout_line:
                    line = stdout_line.strip()
                    if line and not line.startswith('+ echo'):
                        print(f"  {line}")
                    output_lines.append(line)
                
                if stderr_line:
                    line = stderr_line.strip()
                    if line:
                        print(f"  ❌ {line}")
            
            process.wait()
            elapsed = time.time() - start_time
            
            if process.returncode == 0:
                print(f"\n✅ Success in {elapsed:.1f} seconds (No Flutter commands)")
                return True
            else:
                print(f"\n❌ Failed with exit code {process.returncode}")
                print(f"   Time: {elapsed:.1f} seconds")
                return False
                
        except Exception as e:
            print(f"\n⚠️ Error: {e}")
            return False
    
    def run_step_by_step(self):
        """Run commands step by step with user confirmation"""
        print("\n🔧 STEP-BY-STEP EXECUTION (Flutter filtered)")
        print("=" * 60)
        
        successful = 0
        failed = 0
        
        for i, cmd in enumerate(self.bash_commands, 1):
            print(f"\nCommand {i}/{len(self.bash_commands)} (No Flutter):")
            print(f"  {cmd[:100]}..." if len(cmd) > 100 else f"  {cmd}")
            
            # Skip if just EOT/EOF
            if cmd.strip() in ['EOT', 'EOF']:
                print("  ⏭️ Skipping (marker only)")
                continue
            
            response = input("Run this command? (y/n/s=skip all): ")
            
            if response.lower() == 's':
                print("⏹️ Skipping all remaining commands")
                break
            elif response.lower() != 'y':
                print("⏭️ Skipped")
                continue
            
            # Run the command
            try:
                if cmd.startswith('mkdir '):
                    # Handle mkdir
                    dir_path = cmd.replace('mkdir ', '').strip().strip("'\"")
                    os.makedirs(dir_path, exist_ok=True)
                    print(f"  ✅ Created directory: {dir_path}")
                    successful += 1
                elif 'cat >' in cmd:
                    # This is complex - save to script and run
                    temp_script = f"temp_cmd_{i}.sh"
                    with open(temp_script, 'w') as f:
                        f.write("#!/bin/bash\n")
                        f.write(cmd + '\n')
                    os.chmod(temp_script, 0o755)
                    
                    result = subprocess.run(['bash', temp_script], 
                                          capture_output=True, text=True)
                    
                    if result.returncode == 0:
                        print(f"  ✅ File created")
                        successful += 1
                    else:
                        print(f"  ❌ Failed: {result.stderr[:100]}")
                        failed += 1
                    
                    os.remove(temp_script)
                else:
                    print(f"  ⚠️ Unknown command type")
                    failed += 1
                    
            except Exception as e:
                print(f"  ❌ Error: {e}")
                failed += 1
        
        print(f"\n{'='*60}")
        print("📊 FINAL RESULTS (No Flutter):")
        print(f"  ✅ Successful: {successful}")
        print(f"  ❌ Failed: {failed}")
        print(f"  📝 Total: {len(self.bash_commands)}")
        print(f"  🚫 Flutter commands: Filtered out")
        print(f"{'='*60}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python massive_file_runner_fixed.py <code_file> [options]")
        print("\nOptions:")
        print("  --optimized    : Create optimized single script")
        print("  --step-by-step : Run commands one by one")
        print("  --check-only   : Only check, don't run")
        print("  --batch-size N : Commands per batch (default: 1000)")
        print("  --terminal-only: Extract only terminal commands (mkdir, cat, eqf, sed, sid)")
        print("  --filter-type T1,T2: Filter by command types (e.g., mkdir,cat)")
        print("\nExamples:")
        print("  python massive_file_runner_fixed.py codes.txt --terminal-only")
        print("  python massive_file_runner_fixed.py codes.txt --filter-type mkdir,cat")
        print("  python massive_file_runner_fixed.py codes.txt --optimized --batch-size 500")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    # Parse options
    optimized = False
    step_by_step = False
    check_only = False
    terminal_only = False
    filter_types = None
    batch_size = 1000
    
    for i in range(2, len(sys.argv)):
        if sys.argv[i] == '--optimized':
            optimized = True
        elif sys.argv[i] == '--step-by-step':
            step_by_step = True
        elif sys.argv[i] == '--check-only':
            check_only = True
        elif sys.argv[i] == '--terminal-only':
            terminal_only = True
        elif sys.argv[i] == '--filter-type' and i + 1 < len(sys.argv):
            filter_types = sys.argv[i + 1].split(',')
        elif sys.argv[i] == '--batch-size' and i + 1 < len(sys.argv):
            batch_size = int(sys.argv[i + 1])
    
    if not os.path.exists(input_file):
        print(f"❌ File not found: {input_file}")
        sys.exit(1)
    
    # Create runner
    runner = FixedMassiveFileRunner(input_file, batch_size)
    
    # 1. Count lines
    runner.count_lines()
    
    # 2. Extract commands (FIXED VERSION) - automatically skips Flutter
    runner.extract_bash_commands_fixed()
    
    # 3. Apply additional filters if requested
    if terminal_only:
        runner.extract_terminal_commands_only()
    elif filter_types:
        filtered = runner.filter_commands_by_type(filter_types)
        runner.bash_commands = filtered
        runner.total_commands = len(filtered)
    
    if not runner.bash_commands:
        print("⚠️ No bash commands found after filtering")
        sys.exit(1)
    
    # 4. Check directories
    runner.check_directories_exist()
    
    if check_only:
        print("\n✅ Check complete - no errors found")
        return
    
    if step_by_step:
        runner.run_step_by_step()
        return
    
    if optimized:
        # Create and run optimized single script
        script = runner.create_optimized_single_script()
        
        print(f"\n⚠️ Ready to run {runner.total_commands:,} commands (Flutter filtered)")
        response = input("Run optimized script? (y/n): ")
        
        if response.lower() == 'y':
            runner.run_script_with_error_handling(script)
        else:
            print(f"\n📋 You can run it manually:")
            print(f"  bash {script}")
    else:
        # Use batch method
        batches = runner.create_batches_fixed()
        scripts = runner.create_batch_scripts_fixed(batches)
        
        print(f"\n⚠️ Ready to run {len(scripts)} batches (Flutter filtered)")
        response = input("Run all batches? (y/n): ")
        
        if response.lower() == 'y':
            for i, script in enumerate(scripts, 1):
                print(f"\n▶️ Batch {i}/{len(scripts)} (No Flutter)")
                success = runner.run_script_with_error_handling(script)
                if not success:
                    response = input("Continue? (y/n): ")
                    if response.lower() != 'y':
                        break
        else:
            print(f"\n📋 Scripts are in 'batch_scripts_fixed/' directory")

if __name__ == "__main__":
    main()

