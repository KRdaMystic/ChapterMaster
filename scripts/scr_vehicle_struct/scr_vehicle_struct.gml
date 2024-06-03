
global.vehic_stat_list = [ "Manuverability","Durability", "Gunnery", "Survivability", "Sanctity" ];
/* Manuverability: Chance of vehicles to take less damage or flat out ignore it in combat.
Gunnery: Attacks potency when it comes to vehicle weapons whether that be damage or number of attacks.
Survivability:Chance of vehicles being recovered after being destroyed.
Sanctity: Chance of heroic deeds by vehicles whether it be ignoring a fatal hit or going out in a blaze of glory similar to "piety".
*/
global.hull_parts = [ "left_track", "right_track", "left_sponson", "right_sponson", "hull", "turret", "pintle", "engine" ]

global.vehicle_hull_armour=["Light Armour","Heavy Armour","Armoured Ceramite","Artificer Hull"];
global.taint={
    "untainted":{"name":"Untainted"},
    "chaos":{"name":"Chaotic"}
}; 

global.vehic_trait_list = {
	"venerated":{
		Survivability : [5,3,"max"],      
		Gunnery : [5,3, "max"],
        Sanctity : [3,2, "max"],
		display_name : "Venerable",
		flavour_text : "Through deployment in battle on countless worlds this vehicle has gained acclaim within the Chapter ",
		effect:"More likely to be recovered and better shooting in combat"
	},
    "ironside":{
        Durability : [6,3, "max"],
        Survivability : [3,3, "max"],
        Sanctity : [3,2, "max"],
        Manuverability : [-5,2, "max"],
        display_name : "Ironside",
        flavour_text : "Despite being struck multiple times this vehicle has survived blows that would destroy similar craft"
    },
    "nimble":{
        Manuverability : [5,3, "max"],
        Sanctity : [3,3, "max"],
        Durability : [-5,2, "max"],
        display_name : "Nimble",
        flavour_text : "This vehicle displays greater speed and agility than others whether by skill of its crew or machine spirit"
    },
    "standard template":{ 
        Survivability : [10,0, "max"],
        Sanctity : [-5,0, "max"],
        display_name : "STC Compliant",
        flavour_text : "This vehicle has no deviations whatsoever from the STC design making replacement parts extremely easy to procure"
    },
    "custom" : {
        Survivability : [-5,0, "max"],
        Sanctity : [5,0, "max"],
        Gunnery : [5,0, "max"],
        Maneuverability : [5,0, "max"],
        Durability : [5,0, "max"],
        display_name : "Modified",
        flavour_text: "This vehicle has been modified either by its crew or a tech heretic it boasts several improvements that make it more capable"

    },
    "super custom" : {
        Survivability : [-10,0, "max"],
        Sanctity : [10,0, "max"],
        Gunnery : [10,0, "max"],
        Maneuverability : [10,0, "max"],
        Durability : [10,0, "max"],
        display_name : "Heavily Modified",
        flavour_text: "This vehicle is nigh unrecognizeable it has been modified by a heretek bearing completely foreign parts, it is extremely potent but an affront to the machine god"

    }
    /*"blank"{
        Manuverability : [10,5, "max"],
    Gunnery : [10,5, "max"],
    Survivability : [10,5, "max"],
    Sanctity  : [10,5, "max"],
    display_name  : "blank",
    flavour_text : "blank flav text" 
    }*/
}
global.vehic_base_stats = {
    "land_raider":{
        Durability:[40,0],
        Manuverability:[15,3],
        Gunnery:[35,0,],
        Survivability:[35,0],
        Sanctity:[10,5],
        taint:"untainted",
		veh_type:"tank",
        base_group:"astartes_veh"
    },
    "predator":{
        Durability:[35,0],
        Manuverability:[25,5],
        Gunnery:[30,5],
        Survivability:[30,0],
        Sanctity:[5,5],
        taint:"untainted",
		veh_type:"tank",
        base_group:"astartes_veh"
    },
    "rhino":{
        Durability:[30,0],
        Manuverability:[30,5],
        Gunnery:[25,5],
        Survivability:[25,0],
        Sanctity:[5,5],
        taint:"untainted",
		veh_type:"apc",
        base_group:"astartes_veh"
    },
    "whirlwind":{
        Durability:[25,0],
        Manuverability:[20,5],
        Gunnery:[40,5],
        Survivability:[15,0],
        Sanctity:[5,5],
        taint:"untainted",
		veh_type:"firesupp",
        base_group:"astartes_veh"
    },
    "land_speeder":{
        Durability:[35,0],
        Manuverability:[40,0],
        Gunnery:[30,0,],
        Survivability:[15,0],
        Sanctity:[5,5],
        taint:"untainted",
		veh_type:"fav",
        base_group:"astartes_veh"
    },
    "razorback":{
        Durability:[35,0],
        Manuverability:[30,5],
        Gunnery:[35,5,],
        Survivability:[30,5],
        Sanctity:[5,5],
        taint:"untainted",
		veh_type:"apc",
        base_group:"astartes_veh"
    },
    "vindicator":{
        Durability:[35,0],
        Manuverability:[20,5],
        Gunnery:[40,5,],
        Survivability:[35,5],
        Sanctity:[5,5],
        taint:"untainted",
		veh_type:"firesupp",
        base_group:"astartes_veh"
    }

}
	
	function TTRPG_veh_stats(faction, comp, veh, class = "vehicle") constructor{
	Manuverability=0; Survivability=0;Sanctity=0;Gunnery=0;size = 0;planet_location=0;
	if (!instance_exists(obj_controller) && class!="blank"){//game start unit planet location
		planet_location=2;
	}
	taint="none";
	company = comp;	//vehicle company
	vehicle_number = veh;			//vehicle number in company
	stat_point_exp_marker = 0;
	bionics=0;
	static experience =  function(){
		return obj_ini.experience[company][vehicle_number];
	}//get exp
		turn_stat_gains = {};
	static update_exp = function(new_val){obj_ini.experience[company][vehicle_number] = new_val}//change exp
	static add_exp = function(add_val){
		var instace_stat_point_gains = {};
		stat_point_exp_marker += add_val;
		obj_ini.veh_experience[company][vehicle_number] += add_val;
		if (base_group == "astartes_veh"){
			while (stat_point_exp_marker>=10){
				var stat_gains = choose("Manuverability", "Gunnery", "Survivability");
					}
				}				
				self[$ stat_gains]++;
				stat_point_exp_marker-=10;
				if (struct_exists(instace_stat_point_gains, stat_gains)){
					instace_stat_point_gains[$ stat_gains]++;
				} else {
					instace_stat_point_gains[$ stat_gains]=1;
				}
				if (struct_exists(turn_stat_gains, stat_gains)){
					turn_stat_gains[$ stat_gains]++;
				} else {
					turn_stat_gains[$ stat_gains]=1;
				}
				return instace_stat_point_gains;
	}
				
	static armour = function(){ 
		return obj_ini.armour[company][vehicle_number];
	};
	static get_unit_size = function(){
		var unit_role = veh_role();
		var arm = veh_upgrade();
		var sz = 0;
		sz = 10;
	    if (unit_role) = "Land Speeder" {sz-=5;} else if (unit_role = "Land Raider"){sz +=10};
	};


}