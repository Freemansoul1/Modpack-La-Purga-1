-- Store the original render function
local original_render = ISContextMenu.render

-- Cache for all recipes
local allRecipesTable

-- Function to check if an option is a recipe
local function isRecipeOption(name)
    if not allRecipesTable then
        allRecipesTable = {}
        local allRecipes = getAllRecipes()
        for i = 0, allRecipes:size() - 1 do
            local recipe = allRecipes:get(i)
            allRecipesTable[recipe:getName()] = true
        end
    end

    return allRecipesTable[name] == true
end

-- Define the color for recipe options
local recipeTextColor = {
    r = 0.9,
    g = 0.7,
    b = 0.3,
    a = 1
} -- Golden color for recipe text

-- Override the render function
function ISContextMenu:render()
    -- Store the original drawText function
    local original_drawText = self.drawText

    -- Override the drawText function
    self.drawText = function(self, text, x, y, r, g, b, a, font)
        if isRecipeOption(text) then
            -- Use recipe text color for recipe options
            original_drawText(self, text, x, y, recipeTextColor.r, recipeTextColor.g, recipeTextColor.b,
                recipeTextColor.a, font)
        else
            -- Use original colors for non-recipe options
            original_drawText(self, text, x, y, r, g, b, a, font)
        end
    end

    -- Call the original render function
    original_render(self)

    -- Restore the original drawText function
    self.drawText = original_drawText
end
