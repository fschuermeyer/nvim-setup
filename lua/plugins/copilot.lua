-- Some Parts from: https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua
local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    FixError = "Please explain the error in the following text and provide a solution.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
    Commit =
    "> #git:staged \n\n Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit. if the branch name inclues KR-[anynumber]_ put KR-[anynumber]: before the Commit Message."
}

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                filetypes = {
                    yaml = true,
                    markdown = true,
                    gitcommit = true,
                },
                suggestion = {
                    enabled = false,
                    auto_trigger = true,
                    keymap = {
                        accept = false,
                        next = false,
                        prev = false,
                    },
                },
                panel = { enabled = false },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    -- Copilot Chat
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        build = "make tiktoken",
        version = "v3.3.3",                      -- Use a specific version to prevent breaking changes
        dependencies = {
            { "zbirenbaum/copilot.lua" },        -- or zbirenbaum/copilot.lua
            { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            question_header = "  " .. (vim.env.GITHUB_USER or vim.env.USER or "User") .. " ",
            answer_header = "  Copilot ",
            error_header = "## Error ",
            model = "gpt-4o-2024-11-20",
            prompts = prompts,
            mappings = {
                -- Use tab for completion
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options.",
                    insert = "<Tab>",
                },
                -- Close the chat
                close = {
                    normal = "q",
                    insert = "<C-c>",
                },
                -- Reset the chat buffer
                reset = {
                    normal = "<C-x>",
                    insert = "<C-x>",
                },
                -- Show help
                show_help = {
                    normal = "g?",
                },
            },
            window = {
                layout = "vertical",
                width = 0.4,
            },
        },
        config = function(_, opts)
            local chat = require("CopilotChat")
            chat.setup(opts)

            local select = require("CopilotChat.select")
            vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
                chat.ask(args.args, { selection = select.visual })
            end, { nargs = "*", range = true })

            -- Inline chat with Copilot
            vim.api.nvim_create_user_command("CopilotChatInline", function(args)
                chat.ask(args.args, {
                    selection = select.visual,
                    window = {
                        layout = "float",
                        relative = "cursor",
                        width = 1,
                        height = 0.4,
                        row = 1,
                    },
                })
            end, { nargs = "*", range = true })

            -- Restore CopilotChatBuffer
            vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
                chat.ask(args.args, { selection = select.buffer })
            end, { nargs = "*", range = true })

            -- Custom buffer for CopilotChat
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "copilot-*",
                callback = function()
                    vim.opt_local.relativenumber = true
                    vim.opt_local.number = true

                    -- Get current filetype and set it to markdown if the current filetype is copilot-chat
                    local ft = vim.bo.filetype
                    if ft == "copilot-chat" then
                        vim.bo.filetype = "markdown"
                    end
                end,
            })
        end,
        event = "VeryLazy",
        keys = {
            {
                "<leader>a",
                "",
                desc = "+ai",
                mode = { "n", "v" },
            },
            -- Show prompts actions with telescope
            {
                "<leader>ap",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
                desc = "CopilotChat - Prompt actions",
            },
            {
                "<leader>ap",
                ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
                mode = "x",
                desc = "CopilotChat - Prompt actions",
            },
            -- Code related commands
            { "<leader>ae", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
            { "<leader>at", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
            { "<leader>ar", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
            { "<leader>aR", "<cmd>CopilotChatRefactor<cr>",      desc = "CopilotChat - Refactor code" },
            { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
            -- Chat with Copilot in visual mode
            {
                "<leader>av",
                ":CopilotChatVisual",
                mode = "x",
                desc = "CopilotChat - Open in vertical split",
            },
            {
                "<leader>ax",
                ":CopilotChatInline<cr>",
                mode = "x",
                desc = "CopilotChat - Inline chat",
            },
            -- Custom input for CopilotChat
            {
                "<leader>ai",
                function()
                    local input = vim.fn.input("Ask Copilot: ")
                    if input ~= "" then
                        vim.cmd("CopilotChat " .. input)
                    end
                end,
                desc = "CopilotChat - Ask input",
            },
            -- Generate commit message based on the git diff
            {
                "<leader>am",
                "<cmd>CopilotChatCommit<cr>",
                desc = "CopilotChat - Generate commit message for all changes",
            },
            -- Quick chat with Copilot
            {
                "<leader>aq",
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        vim.cmd("CopilotChatBuffer " .. input)
                    end
                end,
                desc = "CopilotChat - Quick chat",
            },
            -- Debug
            { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>",     desc = "CopilotChat - Debug Info" },
            -- Fix the issue with diagnostic
            { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
            -- Clear buffer and chat history
            { "<leader>al", "<cmd>CopilotChatReset<cr>",         desc = "CopilotChat - Clear buffer and chat history" },
            -- Toggle Copilot Chat Vsplit
            { "<leader>aa", "<cmd>CopilotChatToggle<cr>",        desc = "CopilotChat - Toggle" },
            -- Copilot Chat Models
            { "<leader>a?", "<cmd>CopilotChatModels<cr>",        desc = "CopilotChat - Select Models" },
            -- Copilot Chat Agents
            { "<leader>as", "<cmd>CopilotChatAgents<cr>",        desc = "CopilotChat - Select Agents" },
        },
    },
}
