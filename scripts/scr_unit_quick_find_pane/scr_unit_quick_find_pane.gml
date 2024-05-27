// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function mission_name_key(mission){
	mission_key = {
		"meeting_trap" : "Chaos Lord Meeting",
		"meeting" : "Chaos Lord Meeting",
		"succession" : "War of succession",
		"spyrer" : "Kill Spyrer for Inquisitor",
		"mech_raider" : "Provide Land Raider to Mechanicus",
		"mech_bionics" : "Provide Bionic Augmented marines to study",
		"mech_mars" : "Send Techmarines to mars",
		"mech_tomb1": "Explore Mechanicus Tomb",
		"fallen" : "Find Chapter Fallen",
		"recon" : "Recon Mission for Inquisitor",
		"cleanse" : "Cleanse Planet for Inquisitor",
		"tyranid_org" : "Capture Tyranid for Inquisitor",
		"recon" : "Recon Mission for Inquisitor",
		"bomb" : "Bombard World for inquisitor",
		"great_crusade": "Answer Crusade Muster Call",
		"harlequins" : "Harlequin presence Report",
	}
	if (struct_exists(mission_key, mission)){
		return mission_key[$ mission];
	} else{
		return "none"
	}  
}
function scr_unit_quick_find_pane() constructor{
	main_panel = new data_slate();
	tab_buttons = {
	    "fleets":new main_menu_button(spr_ui_but_3, spr_ui_hov_3),
	    "garrisons":new main_menu_button(spr_ui_but_3, spr_ui_hov_3),
	    "hider":new main_menu_button(spr_ui_but_3, spr_ui_hov_3),
	    "missions":new main_menu_button(spr_ui_but_3, spr_ui_hov_3),
	}

	view_area = "fleets";
	update_garrison_log = function(){
		for (var i = 0;i<=200; i++){
			obj_ini.ship_carrying[i]=0
		};
		var u, unit, unit_location, group;
	    garrison_log = {};
	    for (var co=0;co<11;co++){
	    	for (var u=0;u<array_length(obj_ini.TTRPG[co]);u++){
	    		unit = fetch_unit([co, u]);
	    		if (unit.name() == "") then continue;
	    		unit_location = unit.marine_location();
	    		if (unit_location[0]==location_types.planet){
	    			if (!struct_exists(garrison_log, unit_location[2])){
	    				garrison_log[$ unit_location[2]] = {
	    					units:[unit],
	    					vehicles:0, 
	    					garrison:false, 
	    					healers:0, 
	    					techies:0
	    				}
	    			} else {
	    				array_push(garrison_log[$ unit_location[2]].units, unit);
	    			}
	    			group = garrison_log[$ unit_location[2]];
	    			if (unit.IsSpecialist("apoth")){
						group.healers++;
	    			} else if (unit.IsSpecialist("forge")){
						group.techies++;
	    			}
	    		} else if (unit_location[0]==location_types.ship){
	    			obj_ini.ship_carrying[unit.ship_location]+=unit.get_unit_size();
	    		}
	    	}
	    	for (var u=1;u<100;u++){
	    		if (obj_ini.veh_race[co][u]==0) then continue;
	    		if (obj_ini.veh_wid[co][u]>0){
	    			unit_location = obj_ini.veh_loc[co][u];
	    			unit = [co, u];
	    			if (!struct_exists(garrison_log, unit_location)){
	    				garrison_log[$ unit_location] = {
	    					units:[unit],
	    					vehicles:1, 
	    					garrison:false, 
	    					healers:0, 
	    					techies:0
	    				}
	    			} else {
	    				array_push(garrison_log[$ unit_location].units, unit);
	    				garrison_log[$ unit_location].vehicles++;
	    			}
	    		} else if (obj_ini.veh_lid[co][u]>0){
	    			obj_ini.ship_carrying[obj_ini.veh_lid[co][u]]+=scr_unit_size("",obj_ini.veh_role[co][u],true);
	    		}
	    	}
	    }
	    update_mission_log();	
	}

	update_mission_log = function(){
		mission_log=[];
		var temp_log=[];
		var p, i, problems;
		with(obj_star){
			for (i=1;i<=planets;i++){
				problems = p_problem[i];
				for (p = 0;p<array_length(problems);p++){
					if (problems[p] != ""){
						var mission_explain =  mission_name_key(problems[p]);
						if (mission_explain!="none"){
							array_push(temp_log,
								{
									system : name,
									mission : mission_explain,
									time : p_timer[i][p],
									planet : i
								}
							)
						}
					}
				}
			}
		}
		mission_log =temp_log;
	}
	hover_item="none";
	travel_target = [];
	travel_time = 0;
	travel_increments = [];
	is_entered = false;
	start_fleet = 0;
	start_system = 0;
	garrison_log = {};
	mission_log = [];
	hide_sequence=0;
	current_hover=-1;
	hover_count=0;
	main_panel.inside_method = function(){
		var xx = main_panel.XX;
		var yy = main_panel.YY;
		is_entered = scr_hit(xx, yy, xx+main_panel.width, yy+main_panel.height);
		if (view_area=="fleets"){
			var cur_fleet;
			draw_set_color(c_white);
			draw_set_halign(fa_center);
		    draw_text(xx+80, yy+50, "Capitals");
		    draw_text(xx+160, yy+50, "Frigates");
		    draw_text(xx+240, yy+50, "Escorts");
		    draw_text(xx+310, yy+50, "Location");
		    var i = start_fleet;
		    while(i<instance_number(obj_p_fleet) && (yy+90+(20*i)+12 +20)<main_panel.YY+yy+main_panel.height)		
			{
				if (scr_hit(xx+10, yy+90+(20*i),xx+main_panel.width,yy+90+(20*i)+18)){
					draw_set_color(c_gray);
					draw_rectangle(xx+10+20, yy+90+(20*i)-2,xx+main_panel.width-20,yy+90+(20*i)+18, 0)
					draw_set_color(c_white);
				}
			    cur_fleet = instance_find(obj_p_fleet,i);
			    draw_text(xx+80, yy+90+(20*i), cur_fleet.capital_number);
			    draw_text(xx+160, yy+90+(20*i), cur_fleet.frigate_number);
			    draw_text(xx+240, yy+90+(20*i), cur_fleet.escort_number);
			    if (cur_fleet.action=="move"){
			    	draw_text(xx+310, yy+90+(20*i), "Warp Travel");
			    } else {
			    	draw_text(xx+310, yy+90+(20*i), instance_nearest(cur_fleet.x, cur_fleet.y, obj_star).name);
			    }
			    if (point_and_click([xx+10, yy+90+(20*i)-2,xx+main_panel.width,yy+90+(20*i)+18])){
			    	travel_target = [cur_fleet.x, cur_fleet.y];
			    	travel_increments = [(travel_target[0]-obj_controller.x)/15,(travel_target[1]-obj_controller.y)/15];
			    	travel_time = 0;
			    }
			    i++;
			}			
		} else if (view_area=="garrisons"){
			var system_data;
			draw_set_color(c_white);
			draw_set_halign(fa_center);
		    draw_text(xx+80, yy+50, "System");
		    draw_text(xx+160, yy+50, "Troops");
		    draw_text(xx+240, yy+50, "Healers");
		    draw_text(xx+310, yy+50, "Techies");
		    var i = start_system;
		    var registered_hover=false;
		    var system_names = struct_get_names(garrison_log);
			var hover_entered=false;
			var any_hover = false;
			if (hover_item!="none"){
				var loc=hover_item.location;
				hover_entered = scr_hit(loc[0],loc[1],loc[2],loc[3]);
			}		    
		    while(i<array_length(system_names) && (yy+90+(20*i)+12 +20)<main_panel.YY+yy+main_panel.height){
		    	system_data = garrison_log[$system_names[i]];
		    	registered_hover=false;
				if (scr_hit(xx+10, yy+90+(20*i),xx+main_panel.width,yy+90+(20*i)+18)){
					if (!hover_entered){
						draw_set_color(c_gray);
						draw_rectangle(xx+10+20, yy+90+(20*i)-2,xx+main_panel.width-20,yy+90+(20*i)+18, 0);
						draw_set_color(c_white);
						if (current_hover>-1 && current_hover!=i){
							registered_hover=false;
						} else {
							current_hover=i;
							registered_hover=true;
							hover_count++;
						}
					} else {
						if (hover_item.root_item == i){
							draw_rectangle(xx+10+20, yy+90+(20*i)-2,xx+main_panel.width-20,yy+90+(20*i)+18, 0);
						}
					}
				}
			    draw_text(xx+80, yy+90+(20*i), system_names[i]);
			    draw_text(xx+160, yy+90+(20*i), array_length(system_data.units));
			    draw_text(xx+240, yy+90+(20*i), system_data.healers);
			    draw_text(xx+310, yy+90+(20*i), system_data.techies);

			    if (!hover_entered){
    			    if (point_and_click([xx+10, yy+90+(20*i)-2,xx+main_panel.width,yy+90+(20*i)+18])){
    			    	var star = star_by_name(system_names[i]);
    			    	if (star!="none")
    			    	travel_target = [star.x, star.y];
    			    	travel_increments = [(travel_target[0]-obj_controller.x)/15,(travel_target[1]-obj_controller.y)/15];
    			    	travel_time = 0;
    			    }
    			}
			    if (registered_hover){
			    	any_hover=true;
    			    if (hover_count==10){
    			    	hover_item = new hover_box();
    			    	hover_item.relative_x = (mouse_x-xx+(10-10));
    			    	hover_item.relative_y = (mouse_y-(yy+90+(20*i)));
    			    	hover_item.root_item=i;
    			    }
    			}
			    i++;
			}		
			if (!any_hover && !hover_entered){
				current_hover=-1;
				hover_count=0;
				hover_item="none";
			}else if (hover_item!="none"){
		    	if point_and_click(hover_item.draw(xx+10, yy+90+(20*hover_item.root_item), "Manage")){
					group_selection(garrison_log[$system_names[hover_item.root_item]].units,{
						purpose:$"{system_names[hover_item.root_item]} Management",
						purpose_code : "manage",
						number:0,
						system:star_by_name(system_names[hover_item.root_item]).id,
						feature:"none",
						planet : 0,
						selections : []
					});
		    	}
		    }			
		} else if (view_area == "missions"){
			draw_set_color(c_white);
			draw_set_halign(fa_center);
		    draw_text(xx+80, yy+50, "Location");
		    draw_text(xx+160, yy+50, "Mission");
		    draw_text(xx+310, yy+50, "Time Remaining");
		    var i = 0;
		    while(i<array_length(mission_log) && (yy+90+(20*i)+12 +20)<main_panel.YY+yy+main_panel.height)		
			{
				mission = mission_log[i];
				entered=false;
				if (scr_hit(xx+10, yy+90+(20*i),xx+main_panel.width,yy+90+(20*i)+18)){
					draw_set_color(c_gray);
					draw_rectangle(xx+10+20, yy+90+(20*i)-2,xx+main_panel.width-20,yy+90+(20*i)+18, 0)
					draw_set_color(c_white);
					entered=true;
				}
			    draw_text(xx+80, yy+90+(20*i), $"{mission.system} {scr_roman_numerals()[mission.planet-1]}" );
			    draw_set_halign(fa_left);
			    if (entered){
			    	draw_text(xx+160-20, yy+90+(20*i), mission.mission);
			    } else {
			    	draw_text(xx+160-20, yy+90+(20*i), string_truncate(mission.mission,150));
			    }
			    draw_set_halign(fa_center);
			    if (!entered){
			    	draw_text(xx+310, yy+90+(20*i), mission.time);
			    }
			    if (point_and_click([xx+10, yy+90+(20*i)-2,xx+main_panel.width,yy+90+(20*i)+18])){
			    	var star = star_by_name(mission.system);
			    	if (star!="none")
			    	travel_target = [star.x, star.y];
			    	travel_increments = [(travel_target[0]-obj_controller.x)/15,(travel_target[1]-obj_controller.y)/15];
			    	travel_time = 0;
			    }
			    i++;
			}			
		}
		if (array_length(travel_target)==2){
			if (obj_controller.x!=travel_target[0] || obj_controller.y!=travel_target[1]){
				obj_controller.x += travel_increments[0];
				obj_controller.y += travel_increments[1];
				travel_time++;
			} else {
				travel_target=[];		
			}
			if (travel_time==15){
				obj_controller.x = travel_target[0];
				obj_controller.y = travel_target[1];
				travel_target=[];			
			}
		}
	}
	static draw = function(){
		if (obj_controller.menu==0 && obj_controller.zoomed==0 ){
			if (!instance_exists(obj_fleet_select) && !instance_exists(obj_star_select)){
				var xx=__view_get( e__VW.XView, 0 )+0;
				var yy=__view_get( e__VW.YView, 0 )+0;
				var x_draw=xx;
				var lower_draw = yy+main_panel.height+110;
				if (hide_sequence=30) then hide_sequence=0;
				if ((hide_sequence>0 && hide_sequence<15) || (hide_sequence>15 && hide_sequence<30)){
					if (hide_sequence>15){
						x_draw=(xx-main_panel.width) +((main_panel.width/15)*(hide_sequence-15));
					} else {
						x_draw=xx-((main_panel.width/15)*hide_sequence);
					}
					hide_sequence++;
				}
				if (hide_sequence>15 || hide_sequence<15){
					main_panel.draw(x_draw, yy+110, 0.46, 0.75);
					if(tab_buttons.fleets.draw(x_draw,yy+79, "Fleets")){
					    view_area="fleets";
					}
					if (tab_buttons.garrisons.draw(x_draw+115,yy+79, "System Troops")){
					    view_area="garrisons";
					    update_garrison_log();
					}
					if (tab_buttons.missions.draw(x_draw+230,yy+79, "Missions")){
					    view_area="missions";
					    update_garrison_log();
					}					
					if (x_draw+280<xx){
						tab_buttons.hider.draw(xx,lower_draw, "Show")
					} else {
						if (tab_buttons.hider.draw(x_draw+280,lower_draw, "Hide")){
						    hide_sequence++;
						}					
					}					
				} else if (hide_sequence==15){
					if (tab_buttons.hider.draw(xx,lower_draw, "Show")){
					    hide_sequence++;
					}
				}
				/*if (tab_buttons.troops.draw(xx+345,yy+79, "Troops")){
				    view_area="troops";
				}*/							
			}
		}
	}
}

function  hover_box() constructor{
	root_item = "none";
	relative_x=0;
	relative_y=0;
	location = [0,0,0,0];
	static draw = function(xx, yy, button_text){
		location = draw_unit_buttons([xx+relative_x, yy+relative_y], button_text,[1,1], c_green,, fnt_40k_14b, 1);
		return location;
	}
}

function exit_adhoc_manage(){
	menu=0;
    onceh=1;
    cooldown=10;
    click=1;
    hide_banner=0;
    if (instance_exists(selection_data.system)){
   		selection_data.system.alarm[3]=4;
    }		
};
 function update_garrison_manage(){
	location_viewer.update_garrison_log();
	if (struct_exists(location_viewer.garrison_log, selection_data.system.name)){
		var sys_name = selection_data.system.name;
		group_selection(location_viewer.garrison_log[$sys_name].units,selection_data);
		company_data={};
	} else {
		exit_adhoc_manage();		
	} 	
}


function update_general_manage_view(){
    if (obj_controller.managing>0){
        if (managing<=10) and (managing!=0){
        	scr_company_view(managing);
        	company_data = new scr_company_struct(managing);
        }
        if (managing>10) or (managing=0){
			scr_special_view(managing);
			company_data={};
        }            
        cooldown=10;
        sel_loading=0;
        unload=0;
        alarm[6]=30;
    } else if (obj_controller.managing==-1){
        update_garrison_manage();
    }	
}


function transfer_selection(){
	if (instance_number(obj_popup)==0){
        var pip=instance_create(0,0,obj_popup);
        pip.type=5.1;
        pip.company=managing;

        var god=0,nuuum=0,nuuum2=0,checky=0,check_number=0;
        for(var f=1; f<array_length(display_unit); f++){
            if (god==1) then break;
            if (god==0) and (man_sel[f]==1) and (man[f]=="man"){
                god=1;
                pip.unit_role=ma_role[f];
            }
            if (god==0) and (man_sel[f]==1) and (man[f]=="vehicle"){
                god=1;
                pip.unit_role=ma_role[f];
            }
            if (man_sel[f]==1){
                if (man[f]=="man"){
                    nuuum+=1;
                    checky=1;
                    if (ma_role[f]==obj_ini.role[100][7]) then checky=0;
                    if (ma_role[f]==obj_ini.role[100][14]) then checky=0;
                    if (ma_role[f]==obj_ini.role[100][15]) then checky=0;
                    if (ma_role[f]==obj_ini.role[100][16]) then checky=0;
                    if (ma_role[f]==obj_ini.role[100][17]) then checky=0;
                    if (checky==1) then check_number+=1;
                }
                if (man[f]=="vehicle") then nuuum2+=1;
            }
        }
        if (nuuum>1) then pip.unit_role="Marines";
        if (nuuum2>1) then pip.unit_role="Vehicles";
        if (nuuum>0) and (nuuum2>0) then pip.unit_role="Units";
        pip.units=nuuum+nuuum2;
        if (nuuum>0) and (check_number>0){
            if (command_set[1]==0){
                cooldown=8000;
                with(pip){instance_destroy();}
            }
        }
    }
}

function toggle_selection_borders(){
    for(var p=0; p<array_length(display_unit); p++){
        if (man_sel[p]==1) and (man[p]=="man"){
        	if (is_struct(display_unit[p])){
                var unit=display_unit[p];
                var mar_id = unit.marine_number;
                if (unit.ship_location>0) and (obj_ini.loc[unit.company][mar_id]!="Mechanicus Vessel"){
                	unit.is_boarder = !unit.is_boarder;
                }
            }
        }
    }	
}

function add_bionics_selection(){
    var bionics_before=scr_item_count("Bionics");
    if (bionics_before>0){
    	for(var p=0; p<array_length(display_unit); p++){
    		if (man_sel[p]!=0 && is_struct(display_unit[p])){ 
    			var unit = display_unit[p];
    			var comp = unit.company;
    			var mar_id = unit.marine_number;
                if (obj_ini.loc[comp][mar_id]!="Terra") and (obj_ini.loc[comp][mar_id]!="Mechanicus Vessel"){
                    if (string_count("Dread",ma_armour[p])=0){
			        	unit.add_bionics();
                        if (ma_promote[p]==10) then ma_promote[p]=0;
                    }
                }
            }
        }
    }	
}

function jail_selection(){
    for(var f=0; f<array_length(display_unit); f++){
        if (man[f]=="man") and (man_sel[f]==1) and (ma_loc[f]!="Terra") and (ma_loc[f]!="Mechanicus Vessel"){
            if (is_struct(display_unit[f])){
                unit = display_unit[f];
                obj_ini.god[unit.company][unit.marine_number]+=10;
                ma_god[f]+=10;
                man_sel[f]=0;
            }
        }
    }
    if (managing>0){
        alll=0;
        update_general_manage_view();
    } else if (managing==-1){
    	update_garrison_manage()
    }
    sel_loading=0;
    unload=0;
    alarm[6]=7;		
}

function equip_selection(){
	if (instance_number(obj_popup)==0){
	    var f=0,god=0,nuuum=0;
	    var o_wep1="",o_wep2="",o_armour="",o_gear="",o_mobi="";
	    var b_wep1=0,b_wep2=0,b_armour=0,b_gear=0,b_mobi=0;
	    var vih=0, unit;
	    var company = managing<=10 ? managing :10;
	    var prev_role;
	    var allow = true;

	    // Need to make sure that group selected is all the same type
	    for(var f=0; f<array_length(display_unit); f++){

	        // Set different vih depending on unit type
	        if (man_sel[f]!=1) then continue;
	        if (vih==0){
	            if (man[f]=="man" && is_struct(display_unit[f])){
	                unit=display_unit[f];
	                if (unit.armour()!="Dreadnought"){
	                    vih=1;
	                } else {
	                    vih=6;
	                }
	            } else if (man[f]=="vehicle"){
	                if (ma_role[f]=="Land Raider") { vih=50;}
	                else if (ma_role[f]=="Rhino") { vih=51;}
	                else if (ma_role[f]=="Predator") {vih=52;}
	                else if (ma_role[f]=="Land Speeder") { vih=53;}
	                else if (ma_role[f]=="Whirlwind") {vih=54;}
	                prev_role = ma_role[f]=="Whirlwind";
	            }
	        } else {
	            if (vih==1 || vih==6){
	                if (man[f]=="vehicle"){
	                    allow=false;
	                    break;
	                } else if (man[f]=="man" && is_struct(display_unit[f])){
	                    unit=display_unit[f];
	                    if (unit.armour()=="Dreadnought" && vih==1){
	                        allow=false;
	                        break;
	                    } else if (unit.armour()!="Dreadnought" && vih==6){
	                        allow=false;
	                        break;
	                    }
	                }
	            } else if (vih>=50){
	                if (man[f]=="man"){
	                    allow=false;
	                    break;
	                } else if(man[f]=="vehicle"){
	                    if (prev_role != ma_role[f]){
	                        allow=false;
	                        break;
	                    }
	                }
	            }
	        }

	        if (vih>0){
	            nuuum+=1;
	            if (o_wep1=="") and (ma_wep1[f]!="") then o_wep1=ma_wep1[f];
	            if (o_wep2=="") and (ma_wep2[f]!="") then o_wep2=ma_wep2[f];
	            if (o_armour=="") and (ma_armour[f]!="") then o_armour=ma_armour[f];
	            if (o_gear=="") and (ma_gear[f]!="") then o_gear=ma_gear[f];
	            if (o_mobi=="") and (ma_mobi[f]!="") then o_mobi=ma_mobi[f];

	            if (ma_wep1[f]=="") then b_wep1+=1;
	            if (ma_wep2[f]=="") then b_wep2+=1;
	            if (ma_armour[f]=="") then b_armour+=1;
	            if (ma_gear[f]=="") then b_gear+=1;
	            if (ma_mobi[f]=="") then b_mobi+=1;

	            if ((o_wep1!="") and (ma_wep1[f]!=o_wep1)) or (b_wep1==1) then o_wep1="Assortment";
	            if ((o_wep2!="") and (ma_wep2[f]!=o_wep2)) or (b_wep2==1) then o_wep2="Assortment";
	            if ((o_armour!="") and (ma_armour[f]!=o_armour)) or (b_armour==1) then o_armour="Assortment";
	            if ((o_gear!="") and (ma_gear[f]!=o_gear)) or (b_gear==1) then o_gear="Assortment";
	            if ((o_mobi!="") and (ma_mobi[f]!=o_mobi)) or (b_mobi==1) then o_mobi="Assortment";
	        }
	    }

	    if (b_wep1==nuuum) then o_wep1="";
	    if (b_wep2==nuuum) then o_wep2="";
	    if (b_armour==nuuum) then o_armour="";
	    if (b_gear==nuuum) then o_gear="";
	    if (b_mobi==nuuum) then o_mobi="";

	    if (vih>0 && man_size>0 && allow){

	        var pip=instance_create(0,0,obj_popup);
	        pip.type=6;
	        pip.o_wep1=o_wep1;
	        pip.o_wep2=o_wep2;
	        pip.o_armour=o_armour;
	        pip.o_gear=o_gear;
	        pip.n_wep1=o_wep1;
	        pip.n_wep2=o_wep2;
	        pip.n_armour=o_armour;
	        pip.n_gear=o_gear;
	        pip.o_mobi=o_mobi;
	        pip.n_mobi=o_mobi;
	        pip.company=managing;
	        pip.units=nuuum;

	        //Forwards vih selection to the vehicle_equipment variable used in mouse_50 obj_popup and weapons_equip script
	        pip.vehicle_equipment=vih;
	    }
	}		
}

function load_selection(){
    if (man_size>0) and (selecting_location!="Terra") and (selecting_location!="Mechanicus Vessel"){
        scr_company_load(selecting_location);
        menu=30;
        top=1;
    }	
}

function unload_selection(){
    if (man_size>0) and (sel_loading>=1) and (!instance_exists(obj_star_select)) 
    and (selecting_location!="Terra") and (selecting_location!="Mechanicus Vessel") and (selecting_location!="Warp"){
        cooldown=8000;
        var boba=0;
        var unload_star = star_by_name(obj_ini.ship_location[obj_controller.selecting_ship]);
        if (unload_star != "none"){
            if (unload_star.space_hulk!=1){
                boba=instance_create(unload_star.x,unload_star.y,obj_star_select);
                boba.loading=1;
                // selecting location is the ship right now; get it's orbit location
                boba.loading_name=obj_ini.ship_location[selecting_ship];
                boba.depth=self.depth-50;
                // sel_uid=obj_ini.ship_uid[selecting_ship];
                scr_company_load(obj_ini.ship_location[selecting_ship]);
            }
        }
    }	
}

function reset_selection_equipment(){
	var unit;
    for(var f=0; f<array_length(display_unit); f++){
        // If come across a man, set vih to 1
        if (man[f]="man") and (man_sel[f]=1){
        	if (is_struct(display_unit[f])){
        		unit = display_unit[f];
        		unit.set_default_equipment();
        	}
        }
    }
}

function promote_selection(){
        if (sel_promoting==1) and (instance_number(obj_popup)==0){
        var pip=instance_create(0,0,obj_popup);
        pip.type=5;
        pip.company=managing;

        var god=0,nuuum=0;
        for(var f=1; f<array_length(display_unit); f++){
            if ((ma_promote[f]>=1 || is_specialist(ma_role[f], "rank_and_file")  || is_specialist(ma_role[f], "squad_leaders")) && man_sel[f]==1){
                nuuum+=1;
                if (pip.min_exp==0) then pip.min_exp=ma_exp[f];
                pip.min_exp=min(ma_exp[f],pip.min_exp);
            }
            if (god==0) and (ma_promote[f]>=1) and (man_sel[f]==1){
                god=1;
                pip.unit_role=ma_role[f];
            }
        }
        if (nuuum>1) then pip.unit_role="Marines";
        pip.units=nuuum;
    }	
}

//to be run in obj_star_select
function setup_planet_mission_group(){
	man_sel=[];
	display_unit=[];
	man = [];
	return_place = [];
	for (var i=0;i<array_length(obj_controller.display_unit);i++){
		if (obj_controller.man_sel[i]){
			array_push(man_sel, obj_controller.man_sel[i]);
			array_push(display_unit, obj_controller.display_unit[i]);
			array_push(man, obj_controller.man[i]);
			array_push(return_place, obj_controller.ma_lid[i]);
		}
	}
}


function planet_selection_action(){
	var garrison_assignment = (obj_controller.managing>0 && obj_controller.view_squad && loading);
	var xx=__view_get( e__VW.XView, 0 )+0;
	var yy=__view_get( e__VW.YView, 0 )+0;
	if (instance_exists(target)){
		if (loading){
			obj_controller.selecting_planet = 0;
		}
	    for (var i = 0;i<target.planets;i++){
	    	var planet_draw = c_white;
	        if (point_distance(xx+159+(i*41),yy+287,mouse_x,mouse_y)<=22){
	            obj_controller.selecting_planet=i+1;
	            var sel_plan = obj_controller.selecting_planet;
	            var planet_is_allies = scr_is_planet_owned_by_allies(target, sel_plan);
	            if (mouse_check_button_pressed(mb_left)){
	                if (garrison_assignment){
	                	if (planet_is_allies){
		                    var company_data = obj_controller.company_data;
		                    var squad_index = company_data.company_squads[company_data.cur_squad];
		                    var current_squad=obj_ini.squads[squad_index];
		                    current_squad.set_location(loading_name,0,sel_plan);
		                    current_squad.assignment={
		                        type:mission,
		                        location:target.name,
		                        ident:sel_plan,
		                    };
		                    var operation_data = {
		                        type:"squad", 
		                        reference:squad_index,
		                        job:mission,
		                        task_time : 0
		                    };
		                    array_push(target.p_operatives[sel_plan],operation_data);
		                    instance_destroy();
		                } else {
		                	planet_draw = c_red;
		                	tooltip_draw("Can't garrison on non-friendly planet");
		                }
	                } else if (!loading){
	                    garrison = new garrison_force(target.p_operatives[sel_plan]);
	                    feature="";
	                    buttons_selected=false;                 
	                } else if (loading){ 
					    if (sel_plan>0){
					        obj_controller.cooldown=8000;
					        obj_controller.unload=sel_plan;
					        obj_controller.return_object=target;
					        obj_controller.return_size=obj_controller.man_size;
					       with(obj_controller.return_object){// This marks that there are forces upon this planet
					            p_player[obj_controller.unload]+=obj_controller.man_size;
					        }
					        
					        // 135 ; SPECIAL PLANET CRAP HERE
					        
					        // Recon Stuff
					        var recon=0;
					        if (has_problem_planet(sel_plan, "recon",target)) then recon=1;

					        if (recon==1){
					            var arti=instance_create(target.x,target.y,obj_temp7);// Unloading / artifact crap
					            arti.num=sel_plan;
					            arti.alarm[0]=1;
					            arti.loc=obj_controller.selecting_location;
					            arti.managing=obj_controller.managing;
					            arti.type="recon";
					            // Right here should pass the man_sel variables
					            // var i;i=-1;repeat(150){i+=1;arti.man_sel[i]=obj_controller.man_sel[i];}
					            var i=-1;
					            with (arti){
					                setup_planet_mission_group()
					            }
					        }else if (planet_feature_bool(target.p_feature[sel_plan], P_features.Artifact) == 1) and (recon=0){
						
					            var artifact=instance_create(target.x,target.y,obj_temp4);// Unloading / artifact crap
					            artifact.num=sel_plan;
					            artifact.alarm[0]=1;
					            artifact.loc=obj_controller.selecting_location;
					            artifact.managing=obj_controller.managing;

					            with (artifact){
					                setup_planet_mission_group();
					            }
					        }
					        
					        // STC Grab
					        if (planet_feature_bool(target.p_feature[sel_plan], P_features.STC_Fragment) == 1) and (recon=0){
					            var i,tch,mch;i=0;tch=0;mch=0;
					            for (var i=0;i<array_length(obj_controller.display_unit);i++){
					                if (obj_controller.man[i]!="") and (obj_controller.man_sel[i]==1){
					                    if (obj_controller.ma_role[i]=obj_ini.role[100][16]) or ((obj_controller.ma_role[i]="Forge Master")){
					                        tch+=1;
					                    }
					                    if (obj_controller.ma_role[i]="Techpriest"){
					                        mch+=1;
					                    }
					                }
					            }
					            if (tch+mch>0){
					                var arti;arti=instance_create(target.x,target.y,obj_temp4);// Unloading / artifact crap
					                arti.num=sel_plan;
					                arti.alarm[0]=1;
					                arti.loc=obj_controller.selecting_location;
					                arti.managing=obj_controller.managing;
					                arti.tch=tch;
					                arti.mch=mch;
					                // Right here should pass the man_sel variables
					                // var i;i=-1;repeat(150){i+=1;arti.man_sel[i]=obj_controller.man_sel[i];}
					                with (arti){
					                    setup_planet_mission_group();
					                }
					            }
					        }
					        
					        // Ancient Ruins
							var _planet = target.p_feature[sel_plan]
							var _ruins_list =  search_planet_features( _planet, P_features.Ancient_Ruins)
							var _explore_ruins;
					        if (array_length(_ruins_list) > 0){
								for (var _ruin= 0; _ruin < array_length(_ruins_list); _ruin++){
									if ( _planet[_ruins_list[_ruin]].exploration_complete == false){
										 _explore_ruins = _planet[_ruins_list[_ruin]];
										break;
									}else{ _explore_ruins=0;}
								}
								if ( _explore_ruins!= 0){
									obj_controller.current_planet_feature =_explore_ruins;
									obj_controller.current_planet_feature.star = target;
									obj_controller.current_planet_feature.planet = sel_plan;
					                var arti;
					                var pip=instance_create(0,0,obj_popup);
					                pip.title="Ancient Ruins";
					    			var ruins_size =obj_controller.current_planet_feature.ruins_size
					                
					                var nu=planet_numeral_name(sel_plan,target);

					    			 if(_explore_ruins.failed_exploration ==1){ pip.text="The accursed ruins on "+string(nu)+"where your brothers fell still holds many secrets including the remains of your brothers honour demands you avenge them."}else{
					    				 pip.text="Located upon "+string(nu)+$" is a {ruins_size} expanse of ancient ruins, dating back to times long since forgotten.  Locals are superstitious about the place- as a result the ruins are hardly explored.  What they might contain, and any potential threats, are unknown.";
					    				switch (ruins_size){
					    					case "tiny":pip.text += "It's tiny nature means no more than five marines can operate in cohesion without being seperated";
					    					break;
					    					case "small":pip.text += "As a result of it's narrow corridors and tight spaces a squad of any more than 15 would struggle to operate effectivly";
					    					break;
					    					case "medium":pip.text += "Half a standard company (55) could easily operate effectivly in the many wide spaces and caverns";
					    					break;
					    					case "large":pip.text += "A whole company (110) would not be confined in the huge spaces that such a ruin contain";
					    					break;
					    					case "sprawling":pip.text += "The ruins is of an unprecidented size whole legions of old would not feel uncomfortable in such a space"
					    					break;
					    				}
					    				pip.text += ". What is thy will?"
					    			}
					                pip.option1="Explore the ruins.";
					                pip.option2="Do nothing.";
					                pip.option3="Return your marines to the ship.";
					                pip.image="ancient_ruins";
					                
					                arti=instance_create(target.x,target.y,obj_temp4);
					                arti.num=sel_plan;
					                arti.alarm[0]=1;
					                arti.loc=obj_controller.selecting_location;
					                arti.battle_loc=target.name;
					                arti.manag=obj_controller.managing;
					                arti.obj=target;

					                with (arti){
					                    setup_planet_mission_group();
					                }

					                arti.ship_id=obj_controller.ma_lid[1];
					    			obj_controller.current_planet_feature.battle = arti;
								}
					        }

					        instance_destroy();
						}	                	
	                }                
	            }
	        } 
	        xxx=159+(i*41);
	        if (target.craftworld=0) and (target.space_hulk=0){
	        	var sel_plan = i+1;
	        	var temp1=0;
	            with (target){
	                if (p_type[sel_plan]="Lava") then temp1=0;
	                if (p_type[sel_plan]="Desert") then temp1=2;
	                if (p_type[sel_plan]="Dead") then temp1=12;
	                if (p_type[sel_plan]="Hive") then temp1=4;
	                if (p_type[sel_plan]="Temperate") or (p_type[sel_plan]="Feudal") then temp1=8;
	                if (p_type[sel_plan]="Agri") then temp1=6;
	                if (p_type[sel_plan]="Death") then temp1=5;
	                if (p_type[sel_plan]="Ice") then temp1=10;
	                if (p_type[sel_plan]="Forge") then temp1=3;
	                if (p_type[sel_plan]="Daemon") then temp1=14;
	                if (p_type[sel_plan]="Shrine") then temp1=15;
	            }
	            draw_sprite_ext(spr_planets,temp1,xx+xxx, yy+287, 1, 1, 0, planet_draw, 0.9)
	            
	            draw_set_color(global.star_name_colors[target.p_owner[sel_plan]]);

	            draw_text(xx+xxx,yy+255,scr_roman(sel_plan));
	            
	        }	                   
	    }
	    if (target.craftworld=1) then obj_controller.selecting_planet=1;
	    if (target.space_hulk=1) then obj_controller.selecting_planet=1;
	    x=target.x;
	    y=target.y;	    
	}	
}


