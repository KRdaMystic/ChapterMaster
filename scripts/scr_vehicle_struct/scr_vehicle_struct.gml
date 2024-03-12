
global.vehic_stat_list = [ "Manuverability", "Gunnery", "Survivability", "Autonomy" ];
/* Manuverability: Chance of vehicles to take less damage or flat out ignore it in combat.
Gunnery: Attacks potency when it comes to vehicle weapons whether that be damage or number of attacks.
Survivability:Chance of vehicles being recovered after being destroyed.
Autonomy: Chance of heroic deeds by vehicles whether it be ignoring a fatal hit or going out in a blaze of glory similar to "piety".
*/
global.hull.parts = [ "left_track", "right_track", "left_sponson", "right_sponson", "hull", "turret", "engine" ]

global.vehicle_hull_armour=["Heavy Armour","Armoured Ceramite","Artificer Hull"];
global.taint={
    "untainted":{"name":"Untainted"},
    "chaos":{"name":"Chaotic"}
}; 
enum location_types {
	planet,
	ship,
	warp
};

global.vehic_trait_list = {
	"venerated":{
		Survivability : [5,3,"max"],      
		Gunnery : [5,3, "max"],
        Autonomy : [3,2, "max"],
		display_name : "Venerable",
		flavour_text : "Through deployment in battle on countless worlds this vehicle has gained acclaim within the Chapter ",
		effect:"More likely to be recovered and better shooting in combat"
	},
    "ironside":{
        Survivability : [8,3, "max"],
        Autonomy : [3,2, "max"],
        Manuverability : [-3,2, "max"],
        display_name : "Ironside",
        flavour_text : "Despite being struck multiple times this vehicle has survived blows that would destroy similar craft"
    },
    "nimble":{
        Manuverability : [5,3, "max"],
        Autonomy : [3,3, "max"],
        Survivability : [-3,2, "max"],
        display_name : "Nimble",
        flavour_text : "This vehicle displays greater speed and agility than others whether by skill of its crew or machine spirit"
    },
    /*"blank"{
        Manuverability : [10,5, "max"],
    Gunnery : [10,5, "max"],
    Survivability : [10,5, "max"],
    Autonomy  : [10,5, "max"],
    display_name  : "blank",
    flavour_text : "blank flav text" 
    }*/
}
global.vehic_base_stats = {
    "land_raider":{
        Manuverability:[15,3],
        Gunnery:[35,0,],
        Survivability:[35,0],
        Autonomy:[10,5],
        taint:"untainted",
		veh_type:"tank",
        base_group:"astartes_veh"
    },
    "predator":{
        Manuverability:[25,5],
        Gunnery:[30,5],
        Survivability:[30,0],
        Autonomy:[5,0],
        taint:"untainted",
		veh_type:"tank",
        base_group:"astartes_veh"
    },
    "rhino":{
        Manuverability:[30,5],
        Gunnery:[25,5],
        Survivability:[25,0],
        Autonomy:[5,0],
        taint:"untainted",
		veh_type:"apc",
        base_group:"astartes_veh"
    },
    "whirlwind":{
        Manuverability:[20,5],
        Gunnery:[40,5],
        Survivability:[15,0],
        Autonomy:[5,0],
        taint:"untainted",
		veh_type:"artillery",
        base_group:"astartes_veh"
    },
    "land_speeder":{
        Manuverability:[40,0],
        Gunnery:[30,0,],
        Survivability:[15,0],
        Autonomy:[5,0],
        taint:"untainted",
		veh_type:"fav",
        base_group:"astartes_veh"
    },
    "razorback":{
        Manuverability:[30,5],
        Gunnery:[35,5,],
        Survivability:[30,5],
        Autonomy:[5,5],
        taint:"untainted",
		veh_type:"apc",
        base_group:"astartes_veh"
    },
    "vindicator":{
        Manuverability:[20,5],
        Gunnery:[40,5,],
        Survivability:[35,5],
        Autonomy:[5,5],
        taint:"untainted",
		veh_type:"artillery",
        base_group:"astartes_veh"
    }

}
	
	function TTRPG_stats(faction, comp, veh, class = "vehicle") constructor{
	Manuverability=0; Survivability=0;Autonomy=0;Gunnery=0;size = 0;planet_location=0;
	if (!instance_exists(obj_controller) && class!="blank"){//game start unit planet location
		planet_location=2;
	}
	taint="none";
	company = comp;			//marine company
	vehicle_number = veh;			//marine number in company
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
		obj_ini.experience[company][vehicle_number] += add_val;
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
			}
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
		var large_vehicle = ["Land Raider"]
		var small_vehicle = ["Land Speeder"]
	    if (unit_role) = "Land Speeder" {sz-=5;} else if (unit_role = "Land Raider"){sz +=10};
		//var mobi =  mobility_item();
		/*if (mobi == "Jump Pack"){
			sz++;
		}*/
		if (unit_role == "Chapter Master"){sz++}
		size =sz;
		return size
	};


}