# SpecSpec Agent Quick Start Guide

## Installation (2 minutes)

1. Run the setup script:
```bash
cd ~/Desktop/team\ research/specspec
./setup_specspec_agent.sh
```

2. Verify installation:
```bash
specspec
```

## Your First Spec (5 minutes)

### Method 1: Interactive Mode
```bash
claude code --profile specspec
```
Then describe your idea and let the agent guide you through spec creation.

### Method 2: Command Mode
```bash
specspec new "AI-powered recipe optimizer that learns from cooking results"
```

## Always-On Mode

Start the background agent:
```bash
specspec-daemon start
```

Now you can:
- Drop ideas into `~/specspec-agent/requests/new_spec.txt`
- The agent will automatically process them
- Check results in `~/specspec-agent/specs/`

## Common Workflows

### Refine an Existing Spec
```bash
specspec refine ~/specspec-agent/specs/your-spec.md
```

### Capture a Learning Moment
```bash
specspec learn stuck "Tried to implement OAuth but the library documentation was outdated"
```

### Create a Handoff
```bash
specspec handoff ~/specspec-agent/specs/your-spec.md
```

### Check System Status
```bash
specspec status
```

## Tips for Best Results

1. **Start Small**: Use quick specs for initial ideas
   - Don't try to capture everything at once
   - Let the spec evolve naturally

2. **Be Specific**: The agent works best with concrete examples
   - Instead of: "A better todo app"
   - Try: "A todo app that automatically schedules tasks based on energy levels"

3. **Capture Learning**: Document surprises and failures
   - These become the most valuable insights
   - They improve future specs automatically

4. **Use Treaties**: For any collaborative work
   - Even for handoffs to your future self
   - They clarify expectations and prevent confusion

## POV Augments - Supercharge Your Specs

Add specialized perspectives to any spec:

### IndyDevDan POV
Adds agentic layer architecture inspired by multi-agent observability:
```bash
specspec new "code review system" --pov indydevdan
```

### IndyDevDan-Precise POV
Adds exact implementation details for production-ready agent systems:
```bash
specspec new "code review system" --pov indydevdan-precise
```

### Combine Both for Maximum Power
Vision + Implementation = Living System:
```bash
specspec new "code review system" --pov indydevdan --pov indydevdan-precise
```

### Judy's Ass Fire POV 🔥
Stop planning, start building TODAY:
```bash
specspec new "MVP launch" --pov judys-ass-fire
```

### CLARE-ity POV 🤝
Rigorous relational project management for multi-stakeholder initiatives:
```bash
specspec new "cross-functional initiative" --pov clare-ity
```

### Strategic Combinations for Maximum Impact

#### Technical + Human Systems (Long-term Strategic Opportunities)
```bash
specspec new "enterprise AI platform" --pov indydevdan --pov clare-ity
# → Agentic architecture WITH stakeholder alignment and cross-functional collaboration
```

#### Stakeholder Management + Rapid Execution (High-Priority Projects)  
```bash
specspec new "critical system migration" --pov clare-ity --pov judys-ass-fire
# → Rigorous relationship-building WITH urgent execution and clear accountability
```

#### Ultimate Strategic Power Combo
Vision + Human Systems + Speed for the most complex, important initiatives:
```bash
specspec new "company-wide digital transformation" \
  --pov indydevdan-precise \
  --pov clare-ity \
  --pov judys-ass-fire
# → Production-ready technical architecture + stakeholder collaboration + immediate execution
```

## Example Specs to Try

1. **Technical Tool**:
   ```bash
   specspec new "CLI tool that converts design tokens between formats"
   ```

2. **With Agent Architecture**:
   ```bash
   specspec new "Self-healing API gateway" --pov indydevdan
   ```

3. **Production-Ready System**:
   ```bash
   specspec new "Distributed web scraper" --pov indydevdan --pov indydevdan-precise
   ```

4. **Cross-Functional Project**:
   ```bash
   specspec new "Customer data platform migration" --pov clare-ity
   ```

5. **Strategic Technical + Human System**:
   ```bash
   specspec new "AI-powered customer service platform" --pov indydevdan --pov clare-ity
   ```

6. **High-Priority Collaborative Project**:
   ```bash
   specspec new "Emergency incident response system" --pov clare-ity --pov judys-ass-fire
   ```

7. **Stop Talking, Start Doing**:
   ```bash
   specspec new "Team offsite planning" --pov judys-ass-fire
   ```

## Troubleshooting

### Agent Not Responding?
Check if daemon is running:
```bash
specspec-daemon status
```

### Specs Not Generating?
Check the log:
```bash
tail -f ~/specspec-agent/daemon.log
```

### Need More Context?
The agent references:
- Framework docs in `~/Desktop/team research/specspec/`
- Your previous specs in `~/specspec-agent/specs/`
- Learning history in `~/specspec-agent/learning/`

## Next Steps

1. Generate 3-5 specs to get comfortable
2. Try refining a spec based on new insights  
3. Create your first handoff treaty
4. Review the framework docs for advanced features

## Getting Help

- View full documentation: `cat ~/Desktop/team\ research/specspec/SpecSpec_Final_Synthesis.md`
- Check examples: `ls ~/specspec-agent/specs/examples/`
- Review templates: `ls ~/Desktop/team\ research/specspec/templates/`

---
Remember: SpecSpec is a living utility. The more you use it, the better it gets at understanding your needs and generating powerful specifications.