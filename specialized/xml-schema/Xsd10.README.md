# XML Schema 1.0 (XSD)

Minotaur grammar for W3C XML Schema Definition Language 1.0.

## Syntax sketch

```xml
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="order" type="OrderType"/>
  <xs:complexType name="OrderType">
    <xs:sequence>
      <xs:element name="item" maxOccurs="unbounded"/>
    </xs:sequence>
    <xs:attribute name="id" type="xs:string" use="required"/>
  </xs:complexType>
</xs:schema>
```

## AST validation goals

- schema components reference defined or built-in types
- occurrence constraints (minOccurs <= maxOccurs)
- key/keyref fields resolve against selectors

## Extended coverage

Adds redefine, notation, and full facet set for simple-type restrictions.
