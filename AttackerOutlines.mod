return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`AttackerOutlines` encountered an error loading the Darktide Mod Framework.")

		new_mod("AttackerOutlines", {
			mod_script       = "AttackerOutlines/scripts/mods/AttackerOutlines/AttackerOutlines",
			mod_data         = "AttackerOutlines/scripts/mods/AttackerOutlines/AttackerOutlines_data",
			mod_localization = "AttackerOutlines/scripts/mods/AttackerOutlines/AttackerOutlines_localization",
		})
	end,
	packages = {},
}
