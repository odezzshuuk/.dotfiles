return {
  on_attach = function()
    print("This will run when the server attaches!")
  end,
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostic_severity = "fullSolution",
      dotnet_compiler_diagonstics_scope = "fullSolution"
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
}
