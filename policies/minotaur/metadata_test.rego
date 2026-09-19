package minotaur.metadata

# --- fixtures -------------------------------------------------------------

valid_grammar := {
	"path": "programming-languages/sample",
	"files": ["Sample.grammar", "minotaur-metadata.json", "LICENSE"],
	"has_license_file": true,
	"license_spdx": "MIT",
	"metadata": {
		"Id": "develapp.sample",
		"Name": "SampleLanguageGrammar",
		"Vendor": "DevelApp",
		"DisplayName": "Sample Language",
		"Version": "1.0.0",
		"MinotaurVersion": "1.0.0",
		"Description": "Sample grammar demonstrating grammar features.",
		"License": "MIT",
		"Tags": ["sample"],
		"MainFile": "Sample.grammar",
		"Dependencies": [],
		"Documentation": "https://github.com/DevelApp-AI/Minotaur-Grammars",
		"Repository": "https://github.com/DevelApp-AI/Minotaur-Grammars",
		"Author": {"Username": "larsbuch", "FirstName": "Lars", "LastName": "Buch-Jepsen"},
		"PricingModel": "free",
	},
}

# --- tests ----------------------------------------------------------------

test_valid_grammar_passes {
	count(deny) == 0 with input as {"grammars": [valid_grammar]}
}

test_missing_required_field_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.remove(valid_grammar, ["metadata"]),
	]}
}

test_missing_main_file_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(valid_grammar, {"files": ["Other.grammar"]}),
	]}
	contains(msg, "MainFile 'Sample.grammar' not found")
}

test_bad_develapp_id_prefix_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(valid_grammar, {"metadata": object.union(valid_grammar.metadata, {"Id": "sample"})}),
	]}
	contains(msg, "should start with 'develapp.'")
}

test_missing_author_field_is_rejected {
	some msg
	deny[msg] with input as {"grammars": [
		object.union(valid_grammar, {"metadata": object.union(
			object.remove(valid_grammar.metadata, ["Author"]),
			{"Author": {"Username": "larsbuch"}},
		)}),
	]}
	contains(msg, "Author missing required field")
}
