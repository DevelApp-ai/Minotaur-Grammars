package minotaur.metadata

# Required GrammarInfo fields in minotaur-metadata.json
# (must match the marketplace schema in schemas/minotaur-metadata.schema.json).
required_fields[f] {
	f := {
		"Id",
		"Name",
		"Vendor",
		"DisplayName",
		"Version",
		"MinotaurVersion",
		"Description",
		"License",
		"Tags",
		"MainFile",
		"Dependencies",
		"Documentation",
		"Repository",
		"Author",
		"PricingModel",
	}[_]
}

required_author_fields[f] {
	f := {"Username", "FirstName", "LastName"}[_]
}

deny[msg] {
	g := input.grammars[_]
	f := required_fields[_]
	not g.metadata[f]
	msg := sprintf("%s: metadata missing required field '%v'", [g.path, f])
}

deny[msg] {
	g := input.grammars[_]
	f := required_author_fields[_]
	not g.metadata.Author[f]
	msg := sprintf(
		"%s: metadata Author missing required field '%v'",
		[g.path, f],
	)
}

# MainFile must point at a file that exists inside the grammar folder.
deny[msg] {
	g := input.grammars[_]
	not main_file_exists(g)
	msg := sprintf(
		"%s: MainFile '%v' not found in grammar folder",
		[g.path, g.metadata.MainFile],
	)
}

main_file_exists(g) {
	g.files[_] == g.metadata.MainFile
}

# DevelApp grammars use the develapp.<name> Id convention.
deny[msg] {
	g := input.grammars[_]
	g.metadata.Vendor == "DevelApp"
	not startswith(g.metadata.Id, "develapp.")
	msg := sprintf(
		"%s: DevelApp grammar Id should start with 'develapp.', found '%v'",
		[g.path, g.metadata.Id],
	)
}
