# Evita SQL - analysis toolset

Repository contains tools for analyzing SQL requirements for Evita relational database prototype implementation.

## Structure

- `db_init` - initialize PostgreSQL database with required table structure
- `query_testing`
  - `queries` - example SQL queries for testing initial Evita use-cases
  - `queries_measurement` - Java utility for measuring execution times of above use-case SQL queries
  - `data-generator.py` - generator of artificial dataset for testing example SQL queries