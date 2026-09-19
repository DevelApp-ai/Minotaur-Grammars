package minotaur.license

# Allowed SPDX identifiers for grammar LICENSE files.
# DevelApp-authored grammars must use MIT; third-party grammars may use
# their origin license, provided it appears in this allow-list.
allowed_spdx[lic] {
	lic := {
		"MIT",
		"MIT-0",
		"Apache-2.0",
		"BSD-2-Clause",
		"BSD-3-Clause",
		"ISC",
		"MPL-2.0",
		"EPL-2.0",
		"GPL-2.0-only",
		"GPL-3.0-only",
		"LGPL-2.1-only",
		"LGPL-3.0-only",
		"AGPL-3.0-only",
		"Unlicense",
		"CC0-1.0",
	}[_]
}

# Every grammar folder must contain a LICENSE file.
deny[msg] {
	g := input.grammars[_]
	not g.has_license_file
	msg := sprintf("%s: missing LICENSE file", [g.path])
}

# The License field in minotaur-metadata.json must be a valid SPDX identifier.
deny[msg] {
	g := input.grammars[_]
	not g.metadata.License
	msg := sprintf("%s: metadata field 'License' is missing", [g.path])
}

deny[msg] {
	g := input.grammars[_]
	g.metadata.License
	not allowed_spdx[g.metadata.License]
	msg := sprintf(
		"%s: License '%v' is not an allowed SPDX identifier",
		[g.path, g.metadata.License],
	)
}

# Grammars authored by DevelApp are always MIT.
deny[msg] {
	g := input.grammars[_]
	g.metadata.Vendor == "DevelApp"
	g.metadata.License != "MIT"
	msg := sprintf(
		"%s: DevelApp-authored grammar must be MIT, found '%v'",
		[g.path, g.metadata.License],
	)
}

# The SPDX identifier detected in the LICENSE file (license_spdx, may be ""
# when detection failed) must agree with the metadata.
deny[msg] {
	g := input.grammars[_]
	g.license_spdx != ""
	g.license_spdx != g.metadata.License
	msg := sprintf(
		"%s: LICENSE file is '%v' but metadata says '%v'",
		[g.path, g.license_spdx, g.metadata.License],
	)
}
