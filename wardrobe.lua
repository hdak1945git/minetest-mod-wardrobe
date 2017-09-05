local FORM_NAME = "wardrobe_wardrobeSkinForm";
local LAST_SELECTION = -1

local function showForm(player)
    local playerName = player:get_player_name()
    if not playerName or playerName == "" then return end

    local total_skins = #wardrobe.skins
    if total_skins <= 0 then return end

    local fs = "size[5,10]"
    fs = fs.."label[0,0;Change Into:]"
    fs = fs.."textlist[0,1;5,8;wardrobe;"
    for i = 1, total_skins do
        local skin = wardrobe.skins[i]
        local skinName =
            minetest.formspec_escape(wardrobe.skinNames[skin])
            :gsub("#", "##")
        fs = fs..skinName
        if i < total_skins then fs = fs.."," end
    end
    fs = fs.."]"
    fs = fs.."button_exit[0,9;2,2;cancel;Cancel]"
    fs = fs.."button_exit[3,9;2,2;apply;Apply Skin]"

    minetest.show_formspec(playerName, FORM_NAME, fs)
end


minetest.register_on_player_receive_fields(
    function(player, formName, fields)
        if formName ~= FORM_NAME then return end

        local playerName = player:get_player_name()
        if not playerName or playerName == "" then return end
        if not fields then return end

        if fields.wardrobe then
            for e, value in string.gmatch(fields.wardrobe, "(%w+):(%d+)") do
                LAST_SELECTION = tonumber(value)
            end
        elseif fields.apply and LAST_SELECTION >= 0 then
            local skin = wardrobe.skins[LAST_SELECTION]
            local skinName = wardrobe.skinNames[skin]
            wardrobe.changePlayerSkin(playerName, skin)
        end
    end
)


minetest.register_node(
   "wardrobe:wardrobe",
   {
      description = "Wardrobe",
      paramtype2 = "facedir",
      tiles = {
                 "wardrobe_wardrobe_topbottom.png",
                 "wardrobe_wardrobe_topbottom.png",
                 "wardrobe_wardrobe_sides.png",
                 "wardrobe_wardrobe_sides.png",
                 "wardrobe_wardrobe_sides.png",
                 "wardrobe_wardrobe_front.png"
              },
      inventory_image = "wardrobe_wardrobe_front.png",
      sounds = default.node_sound_wood_defaults(),
      groups = { choppy = 3, oddly_breakable_by_hand = 2, flammable = 3 },
      on_rightclick = function(pos, node, player, itemstack, pointedThing)
         showForm(player);
      end
   });

minetest.register_craft(
   {
      output = "wardrobe:wardrobe",
      recipe = { { "group:wood", "group:stick", "group:wood" },
                 { "group:wood", "group:wool",  "group:wood" },
                 { "group:wood", "group:wool",  "group:wood" } }
   });
