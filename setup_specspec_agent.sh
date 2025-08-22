#!/bin/bash

# SpecSpec Agent Setup Script
# This script sets up an always-on Claude Code agent for generating specs

echo "Setting up SpecSpec Agent..."

# Create the agent directory structure
mkdir -p ~/specspec-agent/{prompts,templates,specs,learning,treaties}

# Create the main agent launch script
cat > ~/specspec-agent/specspec.sh << 'EOF'
#!/bin/bash

# SpecSpec Agent Launcher
# Usage: specspec [command] [options]

AGENT_DIR="$HOME/specspec-agent"
SPEC_DIR="$HOME/Desktop/team research/specspec"

case "$1" in
    "new")
        # Generate a new spec
        echo "Launching SpecSpec generator..."
        
        # Save the topic
        TOPIC="${2:-Please provide your idea or topic}"
        
        # Check for POV augments - supports multiple
        POV_AUGMENTS=""
        shift 2  # Skip 'new' and topic
        while [[ $# -gt 0 ]]; do
            if [[ "$1" == "--pov" ]] && [[ -n "$2" ]]; then
                if [[ -n "$POV_AUGMENTS" ]]; then
                    POV_AUGMENTS="$POV_AUGMENTS,$2"
                else
                    POV_AUGMENTS="$2"
                fi
                echo "Applying POV augment: $2"
                shift 2
            else
                shift
            fi
        done
        
        # Build augment references
        AUGMENT_REFS=""
        if [[ -n "$POV_AUGMENTS" ]]; then
            IFS=',' read -ra POVS <<< "$POV_AUGMENTS"
            for pov in "${POVS[@]}"; do
                AUGMENT_REFS="$AUGMENT_REFS
Also apply the $pov POV augment from: $SPEC_DIR/augments/${pov}_POV.md"
            done
        fi
        
        claude code --profile specspec --max-tokens 8000 --resume "
I need to generate a spec using the SpecSpec framework. 

Topic/Idea: $TOPIC

Use the SpecSpec utility framework to create a comprehensive specification that includes:
1. Context and objectives
2. Requirements (functional, learning, treaty, evolutionary)
3. Implementation approach
4. Success metrics
5. Learning capture mechanisms
6. Handoff protocols

Reference the framework at: $SPEC_DIR/SpecSpec_Final_Synthesis.md
$AUGMENT_REFS
"
        ;;
    
    "refine")
        # Refine an existing spec
        echo "Refining spec: $2"
        claude code --profile specspec --resume "
Please refine the existing spec at: $2

Apply the SpecSpec framework principles to:
1. Detect and resolve ambiguities
2. Add missing requirements
3. Enhance learning capture
4. Improve testability
5. Update treaty structures
"
        ;;
    
    "handoff")
        # Create a handoff treaty
        echo "Creating handoff treaty..."
        claude code --profile specspec --resume "
Create a handoff treaty for the spec: $2

Include:
1. Current torch bearer responsibilities
2. Receiving party commitments
3. Learning transfer requirements
4. Success criteria
5. Check-in schedule
"
        ;;
    
    "learn")
        # Capture learning moments
        echo "Capturing learning moment..."
        claude code --profile specspec --resume "
Capture a learning moment:

Type: ${2:-stuck/unstuck/surprised/failed/succeeded}
Context: ${3:-Describe the situation}

Add this to the learning ledger and update relevant specs.
"
        ;;
    
    "status")
        # Check spec status
        echo "Checking SpecSpec system status..."
        claude code --profile specspec --resume "
Review the current state of:
1. Active specs in ~/specspec-agent/specs/
2. Open treaties in ~/specspec-agent/treaties/
3. Recent learning captures
4. System health metrics

Provide a dashboard view.
"
        ;;
    
    *)
        echo "SpecSpec Agent - Living Specification Utility"
        echo ""
        echo "Usage:"
        echo "  specspec new [topic]                                      - Generate a new spec"
        echo "  specspec new [topic] --pov [augment]                     - Generate with POV augment"
        echo "  specspec new [topic] --pov [aug1] --pov [aug2]           - Generate with multiple POVs"
        echo "  specspec refine [file]                                    - Refine an existing spec"
        echo "  specspec handoff [spec]                                   - Create handoff treaty"
        echo "  specspec learn [type]                                     - Capture learning moment"
        echo "  specspec status                                           - System status dashboard"
        echo ""
        echo "Available POV Augments:"
        echo "  indydevdan         - Agentic layer architecture and multi-agent observability"
        echo "  indydevdan-precise - Precise engineering architecture with full observability stack"
        echo "  judys-ass-fire     - Immediate action mode with clear owners and deadlines (TODAY!)"
        echo "  clare-ity          - Rigorous relational project management for multi-stakeholder initiatives"
        echo ""
        echo "Examples:"
        echo "  specspec new 'task manager' --pov indydevdan"
        echo "  specspec new 'AI tutor' --pov indydevdan --pov indydevdan-precise"
        echo "  specspec new 'startup idea' --pov judys-ass-fire  # Stop planning, start building TODAY"
        echo "  specspec new 'ML pipeline' --pov indydevdan-precise --pov judys-ass-fire  # Full power!"
        echo ""
        echo "Strategic Combinations:"
        echo "  specspec new 'enterprise platform' --pov indydevdan --pov clare-ity  # Technical + Human Systems"
        echo "  specspec new 'urgent migration' --pov clare-ity --pov judys-ass-fire  # Stakeholder Alignment + Speed"
        echo "  specspec new 'AI product launch' --pov indydevdan-precise --pov clare-ity --pov judys-ass-fire  # Ultimate Combo"
        echo ""
        echo "Always-on mode: Run 'specspec-daemon' to start background agent"
        ;;
esac
EOF

# Create the daemon script for always-on mode
cat > ~/specspec-agent/specspec-daemon.sh << 'EOF'
#!/bin/bash

# SpecSpec Daemon - Always-on background agent

AGENT_DIR="$HOME/specspec-agent"
LOG_FILE="$AGENT_DIR/daemon.log"
PID_FILE="$AGENT_DIR/daemon.pid"

start_daemon() {
    if [ -f "$PID_FILE" ]; then
        echo "SpecSpec daemon already running (PID: $(cat $PID_FILE))"
        exit 1
    fi
    
    echo "Starting SpecSpec daemon..."
    
    # Background process that monitors for triggers
    (
        while true; do
            # Check for new spec requests
            if [ -f "$AGENT_DIR/requests/new_spec.txt" ]; then
                TOPIC=$(cat "$AGENT_DIR/requests/new_spec.txt")
                rm "$AGENT_DIR/requests/new_spec.txt"
                
                echo "[$(date)] Processing new spec request: $TOPIC" >> "$LOG_FILE"
                ~/specspec-agent/specspec.sh new "$TOPIC" >> "$LOG_FILE" 2>&1
            fi
            
            # Check for learning moments every 72 hours
            LAST_CHECK_FILE="$AGENT_DIR/.last_learning_check"
            if [ ! -f "$LAST_CHECK_FILE" ] || [ $(find "$LAST_CHECK_FILE" -mtime +3 2>/dev/null | wc -l) -gt 0 ]; then
                echo "[$(date)] Running 72-hour learning review..." >> "$LOG_FILE"
                ~/specspec-agent/specspec.sh status >> "$LOG_FILE" 2>&1
                touch "$LAST_CHECK_FILE"
            fi
            
            sleep 60  # Check every minute
        done
    ) & 
    
    echo $! > "$PID_FILE"
    echo "SpecSpec daemon started (PID: $(cat $PID_FILE))"
}

stop_daemon() {
    if [ ! -f "$PID_FILE" ]; then
        echo "SpecSpec daemon not running"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    echo "Stopping SpecSpec daemon (PID: $PID)..."
    kill $PID
    rm "$PID_FILE"
    echo "SpecSpec daemon stopped"
}

case "$1" in
    "start")
        start_daemon
        ;;
    "stop")
        stop_daemon
        ;;
    "restart")
        stop_daemon
        sleep 2
        start_daemon
        ;;
    "status")
        if [ -f "$PID_FILE" ]; then
            echo "SpecSpec daemon running (PID: $(cat $PID_FILE))"
        else
            echo "SpecSpec daemon not running"
        fi
        ;;
    *)
        echo "Usage: specspec-daemon {start|stop|restart|status}"
        ;;
esac
EOF

# Make scripts executable
chmod +x ~/specspec-agent/specspec.sh
chmod +x ~/specspec-agent/specspec-daemon.sh

# Create symlinks for easy access
ln -sf ~/specspec-agent/specspec.sh /usr/local/bin/specspec
ln -sf ~/specspec-agent/specspec-daemon.sh /usr/local/bin/specspec-daemon

# Create request directory for daemon
mkdir -p ~/specspec-agent/requests

# Create Claude Code profile for SpecSpec
cat > ~/.claude/profiles/specspec.yaml << 'EOF'
name: specspec
description: SpecSpec Agent Profile
model: claude-3-opus-20240229
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
EOF

echo "SpecSpec Agent setup complete!"
echo ""
echo "Quick Start:"
echo "  1. Generate a new spec: specspec new 'your idea'"
echo "  2. Start always-on mode: specspec-daemon start"
echo "  3. Check status: specspec status"
echo ""
echo "The agent references your SpecSpec framework at:"
echo "  $HOME/Desktop/team research/specspec/"