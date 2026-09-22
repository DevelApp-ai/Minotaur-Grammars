# Prisma Schema

Minotaur grammar for Prisma Schema, covering the core language subset.

## Syntax sketch

```
model User {
  id    Int    @id @default(autoincrement())
  email String @unique
  posts Post[]
}
```

## AST validation goals

- exactly one @id per model
- relation fields have counterpart relation on target model
- @default values match field type

Implements issue #78.

## Extended coverage

Adds composite @@index/@@unique/@@map attributes, @relation with fields/references, views, composite types, and onDelete actions.

## Coverage completion

The grammar now also covers the remaining language constructs:

- `multiSchema` and `previewFeatures` generator options
- `@db.*` native database type attributes
