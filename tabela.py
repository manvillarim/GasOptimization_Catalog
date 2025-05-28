import re


# Helper function to slugify a string into a filename
def slugify(text):
    # Lowercase, replace non-word characters with hyphens, remove duplicate hyphens
    text = re.sub(r"[^\w\s-]", "", text).strip().lower()
    return re.sub(r"[-\s]+", "-", text)


# List of transformations
transformations = [
    {
        "Transformation": "Replace require with custom errors",
        "Approximate Gas Savings": "verificar",
        "Source": "verificar",
    },
    {
        "Transformation": "Replace dynamic arrays with mappings",
        "Approximate Gas Savings": "verificar",
        "Source": "verificar",
    },
    {
        "Transformation": "Refactoring loops with repeated storage calls",
        "Approximate Gas Savings": "verificar",
        "Source": "verificar",
    },
    {
        "Transformation": "Refactoring loops with a constant comparison",
        "Approximate Gas Savings": "verificar",
        "Source": "verificar",
    },
    {
        "Transformation": "Refactoring loops with repeated computations",
        "Approximate Gas Savings": "verificar",
        "Source": "verificar",
    },
    {
        "Transformation": "Struct Packing",
        "Approximate Gas Savings": "verificar",
        "Source": "verificar",
    }
]


# Function to print Markdown table
def print_markdown_table(transformations):
    header = "| Transformation | Example | Approximate Gas Savings | Source |"
    separator = "|---|---|---|---|"
    print(header)
    print(separator)

    for t in transformations:
        filename = slugify(t["Transformation"]) + ".md"
        example_link = f"[example](examples/{filename})"
        row = f"| {t['Transformation']} | {example_link} | {t['Approximate Gas Savings']} | {t['Source']} |"
        print(row)


# Run
print_markdown_table(transformations)
