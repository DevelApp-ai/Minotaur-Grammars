# XML Schema 1.1 (XSD)

Minotaur grammar for W3C XML Schema Definition Language 1.1.

## Syntax sketch

```xml
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:complexType name="OrderType">
    <xs:openContent mode="interleave"><xs:any namespace="##other"/></xs:openContent>
    <xs:assert test="@total = sum(item/@price)"/>
  </xs:complexType>
</xs:schema>
```

## AST validation goals

- same as XSD 1.0 plus:
- assert test expressions are valid XPath 2.0
- alternatives evaluated against type tables

## Extended coverage: XSD 1.1 additions

Adds `xs:assert` / `xs:assertion`, `xs:alternative` type tables, `xs:openContent` / `xs:defaultOpenContent` wildcard co-processing, and `xs:override`.
