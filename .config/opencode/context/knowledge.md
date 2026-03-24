# Knowledge Search (qmd)

Use `qmd` for searching your markdown knowledge base:

```bash
# Add markdown files to qmd context.
qmd collection add qmd://obsidian "My Obsidian notes"
qmd context add qmd://obsidian "My Obsidian notes"

# Build embeddings once.
qmd embed

# Fast keyword search.
qmd search "work log okr"

# Semantic search.
qmd vsearch "what did i do on Jan first week?"

# Best quality (hybrid + re-ranking).
qmd query "how I handle pagination in iOS app"
```
