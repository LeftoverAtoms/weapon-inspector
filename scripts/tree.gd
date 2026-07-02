extends Control

const PROPERTY_OFFSET: int = 1

@export var gdt: GDT

@export var browser: Tree
@export var viewer: Tree

var _viewer_header: TreeItem
var other: TreeItem

var _selection: Dictionary[StringName, TreeItem]
var _properties: Dictionary[StringName, AssetItem]


func _ready() -> void:
	var root: TreeItem = browser.create_item()

	_viewer_header = viewer.create_item()

	var item_zombie: TreeItem = browser.create_item(root)
	item_zombie.set_text(0, 'Zombies')
	item_zombie.set_selectable(0, false)

	var item_multiplayer: TreeItem = browser.create_item(root)
	item_multiplayer.set_text(0, 'Multiplayer')
	item_multiplayer.set_selectable(0, false)

	var item_campaign: TreeItem = browser.create_item(root)
	item_campaign.set_text(0, 'Campaign')
	item_campaign.set_selectable(0, false)

	var item_other: TreeItem = browser.create_item(root)
	item_other.set_text(0, 'Other')
	item_other.set_selectable(0, false)

	for weapon_name: String in gdt.entries.keys():
		var mode: TreeItem

		if weapon_name.ends_with('_zm'):
			mode = item_zombie
		elif weapon_name.ends_with('_mp'):
			mode = item_multiplayer
		elif weapon_name.ends_with('_cp'):
			mode =  item_campaign
		else:
			mode = item_other

		var category: TreeItem = browser.create_item(mode)
		category.set_text(0, weapon_name)
	
	init_format()


func init_format() -> void:
	var misc: TreeItem = AddCategory( "Misc" )
	AddEntry_String(misc, "displayName", "" ).SetTitle( "Display Name" ).SetHints( "NOWARNINGS" ).SetToolTip( "Localization alias for weapon name displayed on HUD in game." );
	AddEntry_String(misc, "fictionname", "" ).SetTitle( "In-Game Name" ).SetToolTip( "Actual in-game weapon name." );
	AddEntry_String(misc, "modeName", "" ).SetTitle( "Mode Name" ).SetToolTip( "Localization alias for selective fire mode text displayed on HUD in game." );
	AddEntry_String(misc, "parentWeaponName", "" ).SetTitle( "Stat Name" ).SetToolTip( "Name of parent weapon for weapon stats e.g. parent weapons for dogs_bite_mp is dogs_mp." );
	AddEntry_String(misc, "attachmentUnique", "" ).SetTitle( "Attachment Unique Base" ).SetToolTip( "Base name of the attachment unique to load when parsing the attachment uniques." );
	AddEntry_Combo(misc, "playerAnimType", "default | none | other | sniper | rocketlauncher | radio | dualwield | minigun | armminigun | rearclip | handleclip | rearclipsniper | beltfed | g11 | nopump | brawler | riotshield | singleknife | turned | screecher | sword | armblade | onehanded | spikelauncher | hold | club" ).SetTitle( "Player Anim Type" ).SetToolTip( "Select an Player Anim Type - specifies 'playerAnimType' in playeranim.script" );
	AddEntry_String(misc, "DualWieldWeapon", "" ).SetTitle( "Dual Wield Weapon Name" ).SetToolTip( "Weapon that is dual wielded with this one." );
	AddEntry_String(misc, "AIOverlayDescription", "" ).SetTitle( "AI Description" ).SetToolTip( "Localization alias for text shown when crosshair is placed over a friendly. Eg. Rifleman, Submachine Gunner, etc." );
	AddEntry_Combo(misc, "inventoryType", "primary | offhand | item | altmode | gadget | hero" ).SetTitle( "Inventory" ).SetToolTip( "Select what sort of inventory this weapon is." );
	AddEntry_Combo(misc, "weaponType", "bullet | binoculars | riotshield | melee" ).SetTitle( "Type" ).SetToolTip( "Select a weapon type." );
	AddEntry_Combo(misc, "weaponClass", "rifle | mg | smg | pistol | item | spread | Killstreak Alt Stored Weapon | melee | pistol spread | ball" ).SetTitle( "Class" ).SetToolTip( "Select an appropriate class for this weapon." );		
	AddEntry_Combo(misc, "penetrateType", "none | small | medium | large" ).SetTitle( "Penetration" ).SetToolTip( "Type of bullet penetration." );
	AddEntry_Combo(misc, "impactType", "bullet_small | none | bullet_large | bullet_ap | bullet_xtreme | shotgun | grenade_bounce | grenade_explode | rocket_explode | projectile_dud | mortar_shell | tank_shell | blade" ).SetTitle( "Impact Type" ).SetToolTip( "The impact type, used to play impact effects based on surfacetype" );
	AddEntry_Combo(misc, "offhandSlot", "None | Lethal grenade | Tactical grenade | Equipment | Specific use | Gadget" ).SetTitle( "Offhand Slot" );
	AddEntry_Combo(misc, "offhandClass", "None | Smoke Grenade | Frag Grenade | Flash Grenade | Gear | Supply Drop Marker | Gadget" ).SetTitle( "Offhand Class" );
	AddEntry_Combo(misc, "fireType", "Full Auto | Single Shot | Burst | Auto Burst | Minigun | Charge Shot | Charge Shot Burst | Charge Shot Auto Burst | Jetgun | Melee" ).SetTitle( "Fire Type" ).SetToolTip( "Behavior of the weapon when the trigger is held down." );				
	AddEntry_Combo(misc, "clipType", "bottom | top | left | dp28 | ptrs | lmg" ).SetTitle( "Clip Type" ).SetToolTip( "Determines how the clip gets inserted into the weapon." );
	#AddEntry_AssetCombo(misc, "cacWeaponXCam", "xcam" ).SetTitle( "CAC Weapon XCam" ).SetToolTip( "The XCam that specifies the camera and weapon rotation for the CAC when viewing the full weapon." );
	#AddEntry_AssetCombo(misc, "cacAttachmentsXCam", "xcam" ).SetTitle( "CAC Attachments XCam" ).SetToolTip( "The XCam that specifies the camera and weapon rotation for the CAC when viewing specific attachments on the weapon." );
	#AddEntry_AssetCombo(misc, "weaponIconXCam", "xcam" ).SetTitle( "Weapon Icon Preview XCam" ).SetToolTip( "The Xcam for the main weapon icon preview." );
	AddEntry_CheckBox(misc, "nonStowedWeapon", false ).SetTitle( "Non Stowed Weapon" ).SetToolTip( "This weapon will not be drawn when it is stowed (basic knife for example)" );
	AddEntry_CheckBox(misc, "isScavengable", true ).SetTitle( "Is Scavengable" ).SetToolTip( "This weapon can receive additional ammo through the Scavenger system" );
	AddEntry_CheckBox(misc, "skipBattlechatterKill", false ).SetTitle( "Skip Battlechatter Kill" ).SetToolTip( "This weapon will not 'kill' battlechatter to play" );
	AddEntry_CheckBox(misc, "skipBattlechatterReload", false ).SetTitle( "Skip Battlechatter Reload" ).SetToolTip( "This weapon will not 'reload' battlechatter to play" );
	AddEntry_CheckBox(misc, "skipLowAmmoVox", false ).SetTitle( "skip Low Ammo Vox" ).SetToolTip( "This weapon should skip playing low ammo warning voiceovers" );
	AddEntry_CheckBox(misc, "isHybridWeapon", false ).SetTitle( "Is Hybrid Weapon" ).SetToolTip( "This weapon is one half of a hybrid pairing" );
	AddEntry_CheckBox(misc, "firingCancelsSlide", false ).SetTitle( "Firing Cancels Slide" ).SetToolTip( "Slide will get canceled if the trigger is pulled" );
	AddEntry_CheckBox(misc, "isGameplayWeapon", false ).SetTitle( "Is Gameplay Weapon" ).SetToolTip( "This weapon is a special purpose gameplay weapon, for example the syrette or the briefcase_bomb" );
	AddEntry_CheckBox(misc, "disableDeploy", false ).SetTitle( "DisableDeploy" ).SetToolTip( "Weapons that normally could be deployed cannot be deployed if this is checked" );
	AddEntry_Int(misc, "powerLevel", 0, 0, 10000 ).SetTitle( "Power Level" ).SetToolTip( "Power level of the weapon, currently only used to differentiate the 3 levels of the ZOD sword." );
	AddEntry_CheckBox(misc, "disallowUseAsOffhandMelee", false ).SetTitle( "Disallow Use As Offhand Melee" ).SetToolTip( "If checked, will not become ps->meleeWeapon, so it won't replace the existing offhand melee weapon when given" );
	AddEntry_CheckBox(misc, "activatesSlam", false ).SetTitle( "Activates Slam" ).SetToolTip( "Firing weapon will trigger the slam movement." );
	AddEntry_CheckBox(misc, "activatesSlamAsMelee", false ).SetTitle( "Activates Slam From Melee" ).SetToolTip( "The melee button will trigger the slam movement." );
	AddEntry_CheckBox(misc, "activatesSlamAsPowerMelee", false ).SetTitle( "Activates Slam From Power Melee (Right trigger)" ).SetToolTip( "The right trigger button will trigger the slam movement." );
	AddEntry_CheckBox(misc, "activatesSlamAsPowerMeleeLeft", false ).SetTitle( "Activates Slam From Power Melee (Left trigger)" ).SetToolTip( "The left trigger button will trigger the slam movement." );
	AddEntry_CheckBox(misc, "disableSlamInAir", false ).SetTitle( "Disables Slam while airborne" ).SetToolTip( "Disables Slam while airborne." );
	#AddEntry_Float(misc, "slamJumpHeight", 60.0, 0.0, 10000 ).SetTitle( "Slam jump height" ).SetToolTip( "Player's slam jump height." );
	#AddEntry_Float(misc, "slamJumpForwardSpeed", 400.0, 0.0, 10000 ).SetTitle( "Slam jump forward speed" ).SetToolTip( "Player's slam jump forward speed." );
	AddEntry_Int(misc, "additionalTracesOffset", 0, 0, 60 ).SetTitle( "Additional Traces Offset" ).SetToolTip( "Offset to use for the four corners of the square of additional traces. Meant to allow bullet weapons to behave such that aiming doesn't have to be exactly pixel accurate, and incompatible with multi-shot count weapons." );
	AddEntry_CheckBox(misc, "isSupplyDropWeapon", false ).SetTitle( "Is Supply Drop Weapon" ).SetToolTip( "This weapon is a supply drop weapon" );
	#AddEntry_Float(misc, "deathCamTime", 0, -1, 10 ).SetStep( 0.05 ).SetTitle( "Death Cam Time" ).SetToolTip( "Controls how long the player should be in the 3p death cam. Less than zero means use the deathAnimDuration, zero means use the default (currently 1.75), and greater than zero means to use this value" );
	AddEntry_CheckBox(misc, "isSniperWeapon", false ).SetTitle( "Is Sniper Weapon" ).SetToolTip( "This weapon is considered a sniper weapon for various purposes, e.g. disabling sticky aim" );
	AddEntry_CheckBox(misc, "isNotDroppable", false ).SetTitle( "Is Not Droppable" ).SetToolTip( "This weapon will never be dropped if the player is killed, or swaps weapons" );
	AddEntry_CheckBox(misc, "meleeIgnoresLightArmor", false ).SetTitle( "Melee Ignores Light Armor" ).SetToolTip( "This weapon will ignore light armor the player has and do damage directly to the player" );
	AddEntry_CheckBox(misc, "ignoresLightArmor", false ).SetTitle( "Ignores Light Armor" ).SetToolTip( "This weapon will ignore light armor the player has and do damage directly to the player" );
	AddEntry_CheckBox(misc, "ignoresPowerArmor", false ).SetTitle( "Ignores Power Armor" ).SetToolTip( "This weapon will ignore power armor the player has and do damage directly to the player" );
	AddEntry_CheckBox(misc, "bDisallowAtMatchStart", false ).SetTitle( "Round Start Delayed" ).SetToolTip( "Dont allow this weapon to be used at round start." );

	var damage: TreeItem = AddCategory( "Damage" )
	AddEntry_CheckBox(damage, "doNotDamageOwner", false ).SetTitle( "Do Not Damage Owner" ).SetToolTip( "This weapon will not damage the owner" )

	var ammo_options: TreeItem = AddCategory( "Ammo Options" )
	AddEntry_CheckBox(ammo_options, "rifleBullet", true ).SetTitle( "Rifle Bullet" ).SetToolTip( "Uses pistol bullets if not checked. Rifle bullets apply damage to the highest priority hit location (locationdamage.gdt) along the bullet's path, and will go through people. Pistol bullets don't." );
	AddEntry_CheckBox(ammo_options, "armorPiercing", false ).SetTitle( "Armor Piercing" ).SetHints( "NOWARNINGS" ).SetToolTip( "Does damage to armored targets if checked." );
	AddEntry_CheckBox(ammo_options, "doGibbing", false ).SetTitle( "Do Gibbing" ).SetToolTip( "This gun will gib enemy if checked" );
	AddEntry_CheckBox(ammo_options, "doGibbingOnMelee", false ).SetTitle( "Do Gibbing On Melee" ).SetToolTip( "This gun melee will gib enemy if checked" );
	AddEntry_CheckBox(ammo_options, "doAnnihilate", false ).SetTitle( "Do Annihilate" ).SetToolTip( "This gun will gib and annihilate if checked" );
	AddEntry_CheckBox(ammo_options, "doBlowback", false ).SetTitle( "Do Blowback" ).SetToolTip( "This will trigger blowback death anims" );
	AddEntry_Combo(ammo_options, "damageType", "normal | annihilator | bow_partial_charge | bow_full_charge | fireflies | energy_weapon" ).SetTitle( "Damage Type" ).SetToolTip( "Sets a damage type to be used in the playeranim_death.script logic when MOD is not melee or splash" );
	#AddEntry_Float(ammo_options, "maxGibDistance", 1000.0, 0, 20000 ).SetTitle( "Max Gib Distance" );
	#AddEntry_Float(ammo_options, "gibChance", 0.3, 0, 1 ).SetTitle( "Gib Chance" ).SetToolTip( "Chance that lethal damage will produce a gib" );

	var type_options: TreeItem = AddCategory( "Type Options" )
	AddEntry_CheckBox(type_options, "boltAction", false ).SetTitle( "Bolt Action" ).SetToolTip( "Turn this on for bolt-action weapons only. Animation control." );
	AddEntry_Int(type_options, "shotsBeforeRechamber", 0, 0, 255 ).SetTitle( "Shots Before Rechamber" ).SetToolTip( "Number of shots fired before we play the rechamber animation." );
	#AddEntry_Float(type_options, "customFloat0", 0, 0, 1 ).SetTitle( "Rechamber When Firing Stops" ).SetToolTip( "Signifies that rechamber should occur when the player stops firing." );
	AddEntry_CheckBox(type_options, "dualWield", false ).SetTitle( "Dual Wield" ).SetToolTip( "This a dual wield weapon." );
	AddEntry_CheckBox(type_options, "continuousFire", false ).SetTitle( "Continuous Fire" ).SetToolTip( "Enables an in/loop/out set of firing anims for continuous fire weapons (e.g. chainsaw)." );
	AddEntry_CheckBox(type_options, "isCarriedKillstreakWeapon", false ).SetTitle( "isCarriedKillstreakWeapon" ).SetToolTip( "Check if this is a killstreak weapon that the player can equip. (minigun, tv guided missile, etc.)" );
	AddEntry_CheckBox(type_options, "tvguided", false ).SetTitle( "TV Guided" ).SetHints( "NOWARNINGS" ).SetToolTip( "This weapon is a 'tv-guided' type." );

	var alt_mode_options: TreeItem = AddCategory( "Alt Mode Options" )
	AddEntry_String(alt_mode_options, "altWeapon", "" ).SetHints( "NOWARNINGS" ).SetTitle( "Alt Weapon Name" ).SetToolTip( "Weapon to switch to when this weapon's selective fire mode is switched in the game." );
	AddEntry_CheckBox(alt_mode_options, "useAltTagFlash", false ).SetTitle( "FX Use Alt Tag Flash" ).SetToolTip( "Use for weapons that need a different location for tag_flash on the world model. (grenade launchers, flamethrower attachment, etc.)" );
	AddEntry_CheckBox(alt_mode_options, "altWeaponAdsOnly", false ).SetTitle( "Ads Only Alt Weapon" ).SetToolTip( "Use for weapons that can only be switched while in ADS" );
	AddEntry_CheckBox(alt_mode_options, "altWeaponDisableSwitching", false ).SetTitle( "Disable Toggle Weapon Switching" ).SetToolTip( "Does not allow you to switch the alt mode with the toggle weapon button" );
	AddEntry_CheckBox(alt_mode_options, "ignoreAttachments", false ).SetTitle( "Ignore Attachments" ).SetToolTip( "Ignores most things on attachments except for attachment models.  Prevents animations and behaviors from being overridden." );

	var melee_fields: TreeItem = AddCategory( "Melee Fields" )
	AddEntry_CheckBox(melee_fields, "useAsMelee", false ).SetTitle( "Use As Melee" ).SetToolTip( "This weapon will be used for melee attacks, ensure melee animation fields are filled in this weapon." );
	AddEntry_CheckBox(melee_fields, "MeleeCanAssassinate", false ).SetTitle( "Can Assassinate" ).SetToolTip( "This weapon can perform Assassination attacks." );
	AddEntry_CheckBox(melee_fields, "meleeWithLeftHand", false ).SetTitle( "Can Melee With Left Hand" ).SetToolTip( "This weapon can perform a left hand melee attack." );
	AddEntry_CheckBox(melee_fields, "meleeServerResponse", false ).SetTitle( "Server Response Charge" ).SetToolTip( "Does a server validated melee charge." );
	AddEntry_CheckBox(melee_fields, "disallowMeleeChargeInAir", false ).SetTitle( "Disallow Melee Charge In Air" ).SetToolTip( "Does not allow melee charging while attacker is in the air." );
	AddEntry_CheckBox(melee_fields, "disallowMeleeChargeOnPowerMelee", false ).SetTitle( "Disallow Melee Charge On Power Melee" ).SetToolTip( "Disallows the fire on right trigger from performing a melee charge." );
	AddEntry_CheckBox(melee_fields, "useAsMeleeLunge", false ).SetTitle( "Use As Melee Lunge" ).SetToolTip( "When used as a melee weapon it will attempt to lunge when in range." );
	AddEntry_CheckBox(melee_fields, "useAsMeleePowerLoop", false ).SetTitle( "Use As Melee Power Loop" ).SetToolTip( "When performing the power melee attack, the looping anims and logic will be used in place of the normal one shot." );
	AddEntry_CheckBox(melee_fields, "customBool1", false ).SetTitle( "Allow Power Melee Right" ).SetToolTip( "Allow the RT power anim." );
	#AddEntry_Float(melee_fields, "meleeChargeRange", 0.0, 0.0, 1000.0 ).SetTitle( "Melee Charge Range" ).SetToolTip( "Range away from the target melee assist will occur. If zero defualt dvar will be used." );
	#AddEntry_Float(melee_fields, "meleeLungeRange", 0.0, 0.0, 1000.0 ).SetTitle( "Melee Lunge Range" ).SetToolTip( "The attacker will lunge for melee from this far away. If zero defualt dvar will be used." );
	#AddEntry_Float(melee_fields, "meleeChargeMinRange", 70.0, 0.0, 1000.0 ).SetTitle( "Melee Charge Min Range" ).SetToolTip( "Min range away from the target melee assist will occur. If zero defualt dvar will be used." );
	#AddEntry_Float(melee_fields, "chainMeleeRange", 0.0, 0.0, 1000.0 ).SetTitle( "Chain Melee Range" ).SetToolTip( "Radius away from the target that 	a chain melee is allowed to be performed from" );
	#AddEntry_Float(melee_fields, "meleeTime", 0.7, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee" ).SetToolTip( "Rate of fire in seconds per melee attack." );
	#AddEntry_Float(melee_fields, "meleeDelay", 0.25, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Delay" ).SetToolTip( "Delay in seconds between pressing the fire button and the melee attack actually happening." );
	#AddEntry_Float(melee_fields, "meleeAltAnimTime", 0, 0.0, 10.0 ).SetTitle( "Melee Alt Anim Time" ).SetToolTip( "If a second melee is performed within this time window, the alt melee anim will play, if anim is defined, 0.0 to disable." );
	#AddEntry_Float(melee_fields, "meleePowerTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power" ).SetToolTip( "Rate of fire in seconds per melee power attack (right trigger)." );
	#AddEntry_Float(melee_fields, "meleePowerDelay", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power Delay" ).SetToolTip( "Delay in seconds between pressing the fire button and the melee power attack (right trigger) actually happening." );
	#AddEntry_Float(melee_fields, "meleePowerInTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power In" ).SetToolTip( "Rate of fire in seconds per melee power attack (right trigger)." );
	#AddEntry_Float(melee_fields, "meleePowerLoopTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power Loop" ).SetToolTip( "Rate of fire in seconds per melee power attack (right trigger)." );
	#AddEntry_Float(melee_fields, "meleePowerLoopDelay", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power Loop Delay" ).SetToolTip( "Delay in seconds between pressing the fire button and the melee power attack (right trigger) actually happening." );
	#AddEntry_Float(melee_fields, "meleePowerOutTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power Out" ).SetToolTip( "Rate of fire in seconds per melee power attack (right trigger)." );
	#AddEntry_Float(melee_fields, "meleePowerTimeLeft", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power Left" ).SetToolTip( "Rate of fire in seconds per melee power attack (left trigger)." );
	#AddEntry_Float(melee_fields, "meleePowerDelayLeft", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Power Delay Left" ).SetToolTip( "Delay in seconds between pressing the fire button and the melee power attack (left trigger) actually happening." );
	#AddEntry_Float(melee_fields, "meleeChargeTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeChargeDelay", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge Delay" ).SetToolTip( "Delay in seconds between pressing the fire button and the melee charge attack actually happening." );
	#AddEntry_Float(melee_fields, "meleeChargeTimeAbove", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge Above" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeChargeDelayAbove", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge Delay Above" ).SetToolTip( "Delay in seconds between pressing the fire button and the melee charge attack actually happening." );
	#AddEntry_Float(melee_fields, "meleeChargeFatalTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge Fatal" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeChargeFatalCloseTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge Fatal Close" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeChargeMissTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge Miss" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge2Time", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 2" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge2FatalTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 2 Fatal" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge2FatalCloseTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 2 Fatal Close" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge2MissTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 2 Miss" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge3Time", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 3" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge3FatalTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 3 Fatal" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge3FatalCloseTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 3 Fatal Close" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeCharge3MissTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Charge 3 Miss" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeQueueMeleeEarlyTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Queue Melee Early" ).SetToolTip( "Amount in seconds that you would like to allow the melee to be queued before the fire melee animation has finished." );
	#AddEntry_Float(melee_fields, "meleeAssassinationStateTimeTransInTime", 0, 0, 10 ).SetStep( 0.05 ).SetTitle( "Assassination State Trans In Time" ).SetToolTip( "Melee Assassination State raise time." );
	#AddEntry_Float(melee_fields, "meleeAssassinationStateTimeTransOutTime", 0, 0, 10 ).SetStep( 0.05 ).SetTitle( "Assassination State Trans Out Time" ).SetToolTip( "Melee Assassination State lower time." );
	#AddEntry_Float(melee_fields, "meleeAssassinationStateFOV", 65.0, 0.0, 100.0 ).SetStep( 0.05 ).SetTitle( "Assassination State FOV" ).SetToolTip( "Player FOV while in Melee Assassination State." );
	#AddEntry_Float(melee_fields, "meleeLeftTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Left Time" ).SetToolTip( "Rate of fire in seconds per melee attack." );
	#AddEntry_Float(melee_fields, "meleeLeftChargeTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Left Charge Time" ).SetToolTip( "Rate of fire in seconds per melee charge attack." );
	#AddEntry_Float(melee_fields, "meleeLeftChargeFatalTime", 0.0, 0.0, 10.0 ).SetStep( 0.05 ).SetTitle( "Melee Left Charge Fatal Time" ).SetToolTip( "Rate of fire in seconds per melee charge attack fatal." );
	AddEntry_Int(melee_fields, "meleeDamage", 25, 0, 20000 ).SetTitle( "Melee Damage" ).SetToolTip( "Damage per melee hit." );
	AddEntry_Int(melee_fields, "meleeFromBehindDamage", 150, 0, 20000 ).SetTitle( "Melee From Behind Damage" ).SetToolTip( "Damage when you hit another player from behind.  If less than meleeDamage, meleeDamage will be used." );
	AddEntry_Int(melee_fields, "meleePowerDamage", 50, 0, 20000 ).SetTitle( "Melee Power Damage" ).SetToolTip( "Damage per power (right trigger) melee hit." );
	AddEntry_Int(melee_fields, "meleePowerDamageLeft", 50, 0, 20000 ).SetTitle( "Melee Power Damage Left" ).SetToolTip( "Damage per power (left trigger) melee hit." );
	AddEntry_Int(melee_fields, "meleeMaxChainKills", 0, 0, 100 ).SetTitle( "Melee Max Chain Kills" ).SetToolTip( "The max number of chained kills you can perform with this weapon" );
	AddEntry_CheckBox(melee_fields, "meleeJuke", false ).SetTitle( "Melee Juke" ).SetToolTip( "Do a juke to start a melee attack." );
	AddEntry_Int(melee_fields, "meleeJukeTime", 1000, 10, 10000 ).SetTitle( "Melee Juke Time (ms)" ).SetToolTip( "Melee juke time in ms" );
	AddEntry_Int(melee_fields, "meleeJukeAccelTime", 0, 0, 10000 ).SetTitle( "Melee Juke Acceleration Time (ms)" ).SetToolTip( "Melee juke acceleration time in ms" );
	AddEntry_Int(melee_fields, "meleeJukeDecelTime", 250, 10, 10000 ).SetTitle( "Melee Juke Deceleration Time (ms)" ).SetToolTip( "Melee juke deceleration time in ms" );
	#AddEntry_Float(melee_fields, "meleeJukeSpeed", 500, 10, 10000 ).SetTitle( "Melee Juke Speed" ).SetToolTip( "Melee juke speed" );
	AddEntry_CheckBox(melee_fields, "meleeJukeIgnoreActors", false ).SetTitle( "Melee Juke Ignore Actors" ).SetToolTip( "Ignore actor collisions on melee juke." );
	AddEntry_CheckBox(melee_fields, "meleeJukeGroundOnly", false ).SetTitle( "Melee Juke Ground Only" ).SetToolTip( "Disable melee juke when the player is in the air." );
	AddEntry_CheckBox(melee_fields, "meleeAmmoJukeOnly", false ).SetTitle( "Melee Ammo For Juke Only" ).SetToolTip( "Only drain ammo on melee jukes." );
	AddEntry_CheckBox(melee_fields, "cycleMeleeChargeAnims", false ).SetTitle( "Cycle Charge Anims" ).SetToolTip( "Does not reset anim sequence when chain is broken." );
	AddEntry_CheckBox(melee_fields, "noMeleeHint", false ).SetTitle( "No Melee Hint" ).SetToolTip( "Disables text hints." );

	other = AddCategory( "Uncategorized" )


func _on_browser_item_selection(weapon_name: StringName, column: int) -> void:
	_viewer_header.set_text(column, weapon_name)

	var weapon_data: GDF = gdt.entries.get(weapon_name)

	for key: StringName in weapon_data.properties.keys():
		var asset: AssetItem = _properties.get(key)
		if asset == null:
			asset = AddEntry_String(other, key, &'').SetTitle(key)

		#asset.item.set_editable(column, true)
		#asset.item.set_selectable(column, false)

		var value: StringName = weapon_data.properties.get(key)
		asset.item.set_text(column, value)


func _on_browser_multi_selection(item: TreeItem, _column: int, selected: bool) -> void:
	var key: StringName = item.get_text(0)
	var is_dirty: bool = false

	if selected:
		is_dirty = _selection.set(key, item)
	else:
		is_dirty = _selection.erase(key)

	if not is_dirty:
		return

	viewer.columns = PROPERTY_OFFSET + _selection.size()

	_rebuild()


func _rebuild() -> void:
	if viewer.columns < 2:
		return

	# Set properties for each selected 
	for index: int in _selection.keys().size():
		var key: StringName = _selection.keys().get(index)
		_on_browser_item_selection(key, PROPERTY_OFFSET + index)

	# Iterate through each property.
	for key: StringName in _properties.keys():
		var asset: AssetItem = _properties.get(key)

		asset.update_type(PROPERTY_OFFSET)
		var first_value: String = asset.item.get_text(PROPERTY_OFFSET)
		var is_different: bool = false

		for column: int in range(PROPERTY_OFFSET, PROPERTY_OFFSET + _selection.size()):
			asset.update_type(column)

			if asset.item.get_text(column) != first_value:
				is_different = true

		if is_different:
			for column: int in viewer.columns:
				asset.item.set_custom_color(column, Color.RED)
		else:
			for column: int in viewer.columns:
				asset.item.set_custom_color(column, Color.WHITE)


func AddCategory(key: StringName) -> TreeItem:
	var item: TreeItem = viewer.create_item(_viewer_header)
	item.set_text(0, key)
	item.set_selectable(0, false)
	return item


func AddEntry_String(parent: TreeItem, key: StringName, value: StringName) -> AssetItem:
	var asset: AssetItem = _properties.get(key, null)

	if asset == null:
		asset = AssetItem.new(viewer.create_item(parent), &'string')

		# Dictionary is unordered.. but Tree is ordered.
		_properties.set(key, asset)

	return asset


func AddEntry_Int(parent: TreeItem, key: StringName, default: int, min_value: int, max_value: int) -> AssetItem:
	var asset: AssetItem = _properties.get(key, null)

	if asset == null:
		asset = AssetItem.new(viewer.create_item(parent), &'int')
		asset.item.set_cell_mode(1, TreeItem.CELL_MODE_RANGE)
		asset.item.set_range_config(1, min_value, max_value, 0.0)
		#asset.item.set_text(1, str(default))
		asset.item.set_editable(1, true)

		# Dictionary is unordered.. but Tree is ordered.
		_properties.set(key, asset)

	return asset


func AddEntry_CheckBox(parent: TreeItem, key: StringName, value: bool) -> AssetItem:
	var asset: AssetItem = _properties.get(key, null)

	if asset == null:
		asset = AssetItem.new(viewer.create_item(parent), &'checkbox')

		# Dictionary is unordered.. but Tree is ordered.
		_properties.set(key, asset)

	return asset


func AddEntry_Combo(parent: TreeItem, key: StringName, options: StringName) -> AssetItem:
	var asset: AssetItem = _properties.get(key, null)

	if asset == null:
		asset = AssetItem.new(viewer.create_item(parent), &'combo')
		asset.options = options.replace(' | ', ',')

		# Dictionary is unordered.. but Tree is ordered.
		_properties.set(key, asset)

	return asset


class AssetItem:
	var item: TreeItem
	var type: StringName
	var default: StringName
	var options: StringName


	func _init(_item: TreeItem, _type: StringName) -> void:
		item = _item
		type = _type


	func update_type(column: int) -> void:
		match type:
			'string':
				item.set_cell_mode(column, TreeItem.CELL_MODE_STRING)
				item.set_editable(column, true)
				#item.set_text(column, default)
			'checkbox':
				item.set_cell_mode(column, TreeItem.CELL_MODE_CHECK)
				item.set_editable(column, true)
				#item.set_text(column, default)
			'combo':
				item.set_cell_mode(column, TreeItem.CELL_MODE_RANGE)
				item.set_editable(column, true)
				item.set_text(column, options)


	func SetEnum(value: String, column: int) -> AssetItem:
		# Based on Black Ops 3 AWI.
		options = value.replace(' | ', ',')

		item.set_cell_mode(column, TreeItem.CELL_MODE_RANGE)
		item.set_text(column, options)
		item.set_editable(column, true)
		return self


	func SetTitle(text: String) -> AssetItem:
		item.set_text(0, text)
		return self


	func SetToolTip(tooltip: String) -> AssetItem:
		item.set_tooltip_text(0, tooltip)
		return self


	func SetHints(value: String) -> AssetItem:
		return self
