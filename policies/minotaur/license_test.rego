package minotaur.license

# --- fixtures -------------------------------------------------------------

mit_develapp_grammar := {
	"path": "programming-languages/sample",
	"files": ["Sample.grammar", "minotaur-metadata.json", "LICENSE"],
	"has_license_file": true,
	"license_spdx": "MIT",
	"metadata": {"Id": "develapp.sample", "Vendor": "DevelApp", "License": "MIT"},
}

apache_third_party_grammar := {
	"path": "programming-languages/other",
	"files": ["Other.grammar", "minotaur-metadata.json", "LICENSE"],
	"has_license_file": true,
	"license_spdx": "Apache-2.0",
	"metadata": {"Id": "other.example", "Vendor": "ExampleCorp", "License": "Apache-2.0"},
}

# --- tests ----------------------------------------------------------------

test_mit_develapp_grammar_passes {
	count(deny) == 0 with input as {"grammars": [mit_develapp_grammar]}
}

test_third_party_origin_license_passes {
	count(deny) == 0 with input as {"grammars": [apache_third_party_grammar]}
}

test_missing_license_file_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(mit_develapp_grammar, {"has_license_file": false, "path": "x"}),
	]}
	contains(msg, "missing LICENSE file")
}

test_develapp_grammar_with_non_mit_license_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(mit_develapp_grammar, {"metadata": {
			"Id": "develapp.sample",
			"Vendor": "DevelApp",
			"License": "Apache-2.0",
		}}),
	]}
	contains(msg, "DevelApp-authored grammar must be MIT")
}

test_invalid_spdx_identifier_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(mit_develapp_grammar, {"metadata": {
			"Id": "develapp.sample",
			"Vendor": "DevelApp",
			"License": "not-a-license",
		}}),
	]}
	contains(msg, "not an allowed SPDX identifier")
}

test_license_metadata_mismatch_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(mit_develapp_grammar, {"license_spdx": "BSD-3-Clause"}),
	]}
	contains(msg, "LICENSE file is 'BSD-3-Clause' but metadata says 'MIT'")
}
