# SpecSpec Agent Setup Script (Windows PowerShell)
# This script sets up an always-on Claude Code agent for generating specs

Write-Host "Setting up SpecSpec Agent..." -ForegroundColor Green

# Create the agent directory structure
$agentDir = "$env:USERPROFILE\specspec-agent"
Write-Host "Creating directory structure at $agentDir"

New-Item -ItemType Directory -Path "$agentDir\prompts" -Force | Out-Null
New-Item -ItemType Directory -Path "$agentDir\templates" -Force | Out-Null
New-Item -ItemType Directory -Path "$agentDir\specs" -Force | Out-Null
New-Item -ItemType Directory -Path "$agentDir\learning" -Force | Out-Null
New-Item -ItemType Directory -Path "$agentDir\treaties" -Force | Out-Null
New-Item -ItemType Directory -Path "$agentDir\requests" -Force | Out-Null

# Create the main agent launch script (PowerShell version)
$specspecScriptContent = @'
# SpecSpec Agent Launcher (PowerShell)
# Usage: specspec [command] [options]

param(
    [string]$Command,
    [string]$Topic,
    [string[]]$POV
)

$agentDir = "$env:USERPROFILE\specspec-agent"
$specDir = "C:\Users\Owner\Desktop\SpecSpec\SpecSpec-v1\specspec"

switch ($Command) {
    "new" {
        Write-Host "Launching SpecSpec generator..." -ForegroundColor Yellow
        
        if (-not $Topic) {
            $Topic = "Please provide your idea or topic"
        }
        
        # Build augment references
        $augmentRefs = ""
        if ($POV) {
            foreach ($pov in $POV) {
                $augmentRefs += "`nAlso apply the $pov POV augment from: $specDir\augments\${pov}_POV.md"
                Write-Host "Applying POV augment: $pov" -ForegroundColor Cyan
            }
        }
        
        $prompt = @"
I need to generate a spec using the SpecSpec framework. 

Topic/Idea: $Topic

Use the SpecSpec utility framework to create a comprehensive specification that includes:
1. Context and objectives
2. Requirements (functional, learning, treaty, evolutionary)
3. Implementation approach
4. Success metrics
5. Learning capture mechanisms
6. Handoff protocols

Reference the framework at: $specDir\SpecSpec Unified Synthesis.md$augmentRefs
"@
        
        # Launch Claude Code with the prompt
        claude code --profile specspec --max-tokens 8000 --resume $prompt
    }
    
    "refine" {
        Write-Host "Refining spec: $Topic" -ForegroundColor Yellow
        $prompt = @"
Please refine the existing spec at: $Topic

Apply the SpecSpec framework principles to:
1. Detect and resolve ambiguities
2. Add missing requirements
3. Enhance learning capture
4. Improve testability
5. Update treaty structures
"@
        claude code --profile specspec --resume $prompt
    }
    
    "handoff" {
        Write-Host "Creating handoff treaty..." -ForegroundColor Yellow
        $prompt = @"
Create a handoff treaty for the spec: $Topic

Include:
1. Current torch bearer responsibilities
2. Receiving party commitments
3. Learning transfer requirements
4. Success criteria
5. Check-in schedule
"@
        claude code --profile specspec --resume $prompt
    }
    
    "learn" {
        Write-Host "Capturing learning moment..." -ForegroundColor Yellow
        $learnType = if ($Topic) { $Topic } else { "stuck/unstuck/surprised/failed/succeeded" }
        $context = if ($POV[0]) { $POV[0] } else { "Describe the situation" }
        
        $prompt = @"
Capture a learning moment:

Type: $learnType
Context: $context

Add this to the learning ledger and update relevant specs.
"@
        claude code --profile specspec --resume $prompt
    }
    
    "status" {
        Write-Host "Checking SpecSpec system status..." -ForegroundColor Yellow
        $prompt = @"
Review the current state of:
1. Active specs in $agentDir\specs\
2. Open treaties in $agentDir\treaties\
3. Recent learning captures
4. System health metrics

Provide a dashboard view.
"@
        claude code --profile specspec --resume $prompt
    }
    
    default {
        Write-Host "SpecSpec Agent - Living Specification Utility" -ForegroundColor Green
        Write-Host ""
        Write-Host "Usage:" -ForegroundColor White
        Write-Host "  specspec new [topic] [-POV augment1,augment2]     - Generate a new spec" -ForegroundColor Gray
        Write-Host "  specspec refine [file]                            - Refine an existing spec" -ForegroundColor Gray
        Write-Host "  specspec handoff [spec]                           - Create handoff treaty" -ForegroundColor Gray
        Write-Host "  specspec learn [type] [context]                   - Capture learning moment" -ForegroundColor Gray
        Write-Host "  specspec status                                   - System status dashboard" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Available POV Augments:" -ForegroundColor Cyan
        Write-Host "  indydevdan         - Agentic layer architecture and multi-agent observability" -ForegroundColor Gray
        Write-Host "  indydevdan-precise - Precise engineering architecture with full observability stack" -ForegroundColor Gray
        Write-Host "  judys-ass-fire     - Immediate action mode with clear owners and deadlines (TODAY!)" -ForegroundColor Gray
        Write-Host "  clare-ity          - Rigorous relational project management for multi-stakeholder initiatives" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Examples:" -ForegroundColor Yellow
        Write-Host "  specspec new 'task manager' -POV indydevdan" -ForegroundColor Gray
        Write-Host "  specspec new 'AI tutor' -POV indydevdan,indydevdan-precise" -ForegroundColor Gray
        Write-Host "  specspec new 'startup idea' -POV judys-ass-fire  # Stop planning, start building TODAY" -ForegroundColor Gray
    }
}
'@

Set-Content -Path "$agentDir\specspec.ps1" -Value $specspecScriptContent

# Create batch file wrapper for easier command line access
$batchWrapper = @"
@echo off
powershell.exe -ExecutionPolicy Bypass -File "%USERPROFILE%\specspec-agent\specspec.ps1" %*
"@

Set-Content -Path "$agentDir\specspec.bat" -Value $batchWrapper

# Add to PATH if not already there
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$agentDir*") {
    $newPath = "$currentPath;$agentDir"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Host "Added $agentDir to user PATH" -ForegroundColor Green
    Write-Host "You may need to restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
}

# Create Claude Code profile directory if it doesn't exist
$claudeProfileDir = "$env:USERPROFILE\.claude\profiles"
if (-not (Test-Path $claudeProfileDir)) {
    New-Item -ItemType Directory -Path $claudeProfileDir -Force | Out-Null
}

# Create Claude Code profile for SpecSpec
$profileContent = @"
name: specspec
description: SpecSpec Agent Profile
model: claude-sonnet-4-20250514
temperature: 0.7
max_tokens: 8000
system_prompt: |
  You are the SpecSpec Agent, a sophisticated utility for generating living specifications.
  
  Your core capabilities:
  1. Generate comprehensive specs using the SpecSpec framework
  2. Detect and resolve ambiguities
  3. Create learning capture mechanisms
  4. Design handoff protocols and treaties
  5. Evolve specs based on usage and feedback
  
  Always reference the framework documentation and maintain:
  - Functional requirements
  - Learning requirements
  - Treaty requirements
  - Evolutionary requirements
  
  Focus on creating practical, actionable specifications that can evolve.
"@

Set-Content -Path "$claudeProfileDir\specspec.yaml" -Value $profileContent

Write-Host ""
Write-Host "SpecSpec Agent setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick Start:" -ForegroundColor Cyan
Write-Host "  1. Generate a new spec: specspec new 'your idea'" -ForegroundColor White
Write-Host "  2. With POV augment: specspec new 'your idea' -POV judys-ass-fire" -ForegroundColor White
Write-Host "  3. Check status: specspec status" -ForegroundColor White
Write-Host ""
Write-Host "The agent references your SpecSpec framework at:" -ForegroundColor Gray
Write-Host "  C:\Users\Owner\Desktop\SpecSpec\SpecSpec-v1\specspec\" -ForegroundColor Gray
Write-Host ""
Write-Host "Note: Restart your terminal for PATH changes to take effect" -ForegroundColor Yellow