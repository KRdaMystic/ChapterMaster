var __b__;
__b__ = action_if_number(obj_saveload, 0, 0);
if __b__
{
__b__ = action_if_number(obj_drop_select, 0, 0);
if __b__
{
__b__ = action_if_variable(obj_controller.diplomacy, 0, 0);
if __b__
{

draw_set_font(fnt_fancy);
draw_set_halign(fa_center);
draw_set_color(0);

if (obj_controller.menu=60) then exit;

var xx, yy, dist, close;
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;
dist=999;close=false;




if (debug!=0) then exit;

    //TODO centralise this logic
    if (instance_exists(obj_fleet_select)){
         if (obj_fleet_select.currently_entered) then exit;
    }

if (loading=0){
    if (instance_exists(target) and (obj_controller.cooldown<=0)){
        if (target.planets>=1){
            dist=point_distance(xx+159,yy+287,mouse_x,mouse_y);   
            if (dist<=16){
                obj_controller.selecting_planet=1;
                garrison = new garrison_force(target.p_operatives[obj_controller.selecting_planet]);
                feature="";
                buttons_selected=false;  
            }
        }
        if (target.planets>=2){
            dist=point_distance(xx+200,yy+287,mouse_x,mouse_y);   
           if (dist<=16){
                obj_controller.selecting_planet=2;
                feature="";
                garrison = new garrison_force(target.p_operatives[obj_controller.selecting_planet]);
                buttons_selected=false; 
            }
        }
        if (target.planets>=3){
            dist=point_distance(xx+241,yy+287,mouse_x,mouse_y);   
            if (dist<=16){
                obj_controller.selecting_planet=3;
                feature="";
                garrison = new garrison_force(target.p_operatives[obj_controller.selecting_planet]);
                buttons_selected=false;  
            }
        }
        if (target.planets>=4){
            dist=point_distance(xx+282,yy+287,mouse_x,mouse_y);   
           if (dist<=16){
                obj_controller.selecting_planet=4;
                feature="";
                garrison = new garrison_force(target.p_operatives[obj_controller.selecting_planet]);
                buttons_selected=false;  
            }
        }
    }

    // Exit button
    if (mouse_x>=xx+274) and (mouse_y>=yy+426) and (mouse_x<xx+337) and (mouse_y<yy+451) and (obj_controller.cooldown<=0){
        obj_controller.sel_system_x=0;
		obj_controller.sel_system_y=0;
        obj_controller.popup=0;
		obj_controller.cooldown=8000;
		obj_controller.selecting_planet=0;
        instance_destroy();
    }

}

if (obj_controller.cooldown<=0) and (loading=1){
	if (point_in_rectangle(mouse_x, mouse_y,xx+274,yy+426,xx+337,yy+451)){
        obj_controller.selecting_planet=0;
        obj_controller.cooldown=8000;
        if (obj_controller.menu=1 && obj_controller.managing>0 && obj_controller.view_squad){
            var company_data = obj_controller.company_data;
            var squad_index = company_data.company_squads[company_data.cur_squad];
            var current_squad=obj_ini.squads[squad_index];
            if (obj_controller.selecting_planet>0){
                var planet =obj_controller.selecting_planet;
                for (var i=0;i<array_length(target.p_operatives[planet]);i++){
                    operation = target.p_operatives[planet][i];
                    if (operation.type=="squad" && operation.reference == squad_index){
                        array_delete(target.p_operatives[planet], i, 1);
                    }
                } 
            }          
            current_squad.assignment="none";
        }
        instance_destroy();
    }
    if (obj_controller.menu=1 && obj_controller.managing>0 && obj_controller.view_squad && obj_controller.selecting_planet>0){
        var company_data = obj_controller.company_data;
        var squad_index = company_data.company_squads[company_data.cur_squad];
        var current_squad=obj_ini.squads[squad_index];
        current_squad.set_location(loading_name,0,obj_controller.selecting_planet);
        current_squad.assignment={
            type:mission,
            location:target.name,
            ident:obj_controller.selecting_planet,
        };
        var operation_data = {
            type:"squad", 
            reference:squad_index,
            job:mission,
            task_time : 0
        };
        array_push(target.p_operatives[obj_controller.selecting_planet],operation_data)
    }     
    if (obj_controller.selecting_planet>0){
        obj_controller.cooldown=8000;
        obj_controller.unload=obj_controller.selecting_planet;
        obj_controller.return_object=target;
        obj_controller.return_size=obj_controller.man_size;
       with(obj_controller.return_object){// This marks that there are forces upon this planet
            p_player[obj_controller.unload]+=obj_controller.man_size;
        }
        
        // 135 ; SPECIAL PLANET CRAP HERE
        
        // Recon Stuff
        var recon=0;
        if (has_problem_planet(obj_controller.selecting_planet, "recon",target)) then recon=1;

        if (recon==1){
            var arti=instance_create(target.x,target.y,obj_temp7);// Unloading / artifact crap
            arti.num=obj_controller.selecting_planet;
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
        }
        
        // Artifact Grab
        if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.Artifact) == 1) and (recon=0){
	
            var arti=instance_create(target.x,target.y,obj_temp4);// Unloading / artifact crap
            arti.num=obj_controller.selecting_planet;
            arti.alarm[0]=1;
            arti.loc=obj_controller.selecting_location;
            arti.managing=obj_controller.managing;

            with (arti){
                setup_planet_mission_group()
            }
        }
        
        // STC Grab
        if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.STC_Fragment) == 1) and (recon=0){
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
                arti.num=obj_controller.selecting_planet;
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
		var _planet = target.p_feature[obj_controller.selecting_planet]
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
				obj_controller.current_planet_feature.planet = obj_controller.selecting_planet;
                var arti;
                var pip=instance_create(0,0,obj_popup);
                pip.title="Ancient Ruins";
    			var ruins_size =obj_controller.current_planet_feature.ruins_size
                
                var nu=string(target.name);
                if (obj_controller.selecting_planet=1) then nu+=" I";if (obj_controller.selecting_planet=2) then nu+=" II";
                if (obj_controller.selecting_planet=3) then nu+=" III";if (obj_controller.selecting_planet=4) then nu+=" IV";
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
                pip.option1="Explore the ruins.";pip.option2="Do nothing.";pip.option3="Return your marines to the ship.";pip.image="ancient_ruins";
                
                arti=instance_create(target.x,target.y,obj_temp4);
                arti.num=obj_controller.selecting_planet;arti.alarm[0]=1;
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


attack=0;bombard=0;raid=0;purge=0;

if (player_fleet>0) and (imperial_fleet+mechanicus_fleet+inquisitor_fleet+eldar_fleet+ork_fleet+tau_fleet+heretic_fleet>0) and (obj_controller.cooldown<=0){
    var i,x3,y3;i=0;
    // x3=xx+46;y3=yy+252;
    x3=xx+49;y3=yy+441;
    
    var combating;combating=0;
    
    repeat(7){i+=1;
        if (en_fleet[i]>0) and (mouse_x>=x3-24) and (mouse_y>=y3-24) and (mouse_x<x3+48) and (mouse_y<y3+48) and (obj_controller.cooldown<=0){
            obj_controller.cooldown=8;combating=en_fleet[i];
        }
        x3+=64;
    }
    
    if (combating>0){
        obj_controller.combat=combating;
    
        var ii, xx, yy, good, pfleet, enemy_fleet, allied_fleet, ecap, efri, eesc, acap, afri, aesc, e1,e2,e3;
        ii=0;xx=0;yy=0;good=0;pfleet=0;enemy_fleet=0;allied_fleet=0;ecap=0;efri=0;eesc=0;e1=0;e2=0;e3=0;
        ii=-1;repeat(20){ii+=1;enemy_fleet[ii]=0;allied_fleet[ii]=0;ecap[ii]=0;efri[ii]=0;eesc[ii]=0;acap[ii]=0;afri[ii]=0;aesc[ii]=0;}
        
        ii=0;good=1;
        
        obj_controller.temp[1099]=target.name;
        with(obj_p_fleet){if (action!=""){x-=20000;y-=20000;}}
        pfleet=instance_nearest(target.x,target.y,obj_p_fleet);
        with(obj_p_fleet){if (x<-6000) and (y<-6000){x+=20000;y+=20000;}}
        ii=target;
        
        with(obj_temp3){instance_destroy();}
        
        if (good=1){// trying to find the star
            instance_activate_object(obj_star);
            obj_controller.x=ii.x;obj_controller.y=ii.y;// show=current_battle;
            
            strin[1]=string(pfleet.capital_number);
            strin[2]=string(pfleet.frigate_number);
            strin[3]=string(pfleet.escort_number);
            // pull health values here
            strin[4]=string(pfleet.capital_health);
            strin[5]=string(pfleet.frigate_health);
            strin[6]=string(pfleet.escort_health);
            
            // pull enemy ships here
            
            var e;e=1;
            repeat(9){e+=1;
                if (target.present_fleet[e]>0){
                    obj_controller.temp[1070]=target.id;
                    obj_controller.temp[1071]=e;
                    obj_controller.temp[1072]=0;
                    obj_controller.temp[1073]=0;
                    obj_controller.temp[1074]=0;
                    
                    with(obj_temp2){instance_destroy();}
                    with(obj_temp3){instance_destroy();}
                    with(obj_en_fleet){
                        if (orbiting=obj_controller.temp[1070]) and (owner=obj_controller.temp[1071]){
                            obj_controller.temp[1072]+=capital_number;
                            obj_controller.temp[1073]+=frigate_number;
                            obj_controller.temp[1074]+=escort_number;
                            if (string_count("BLOOD",trade_goods)>0) then instance_create(x,y,obj_temp2);
                            if (string_lower(trade_goods)="csm") then instance_create(x,y,obj_temp3);
                        }
                    }
                    
                    var l1,l2;l1=0;l2=0;
                    if (obj_controller.faction_status[e]!="War") and (e!=combating){
                        repeat(10){l1+=1;if (allied_fleet[l1]=0) and (l2=0) then l2=l1;}
                        allied_fleet[l2]=e;
                        acap[l2]=obj_controller.temp[1072];
                        afri[l2]=obj_controller.temp[1073];
                        aesc[l2]=obj_controller.temp[1074];
                    }
                    if (obj_controller.faction_status[e]="War") or (e=9) or (e=combating){
                        repeat(10){l1+=1;if (enemy_fleet[l1]=0) and (l2=0) then l2=l1;}
                        enemy_fleet[l2]=e;
                        ecap[l2]=obj_controller.temp[1072];
                        efri[l2]=obj_controller.temp[1073];
                        eesc[l2]=obj_controller.temp[1074];
                    }
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        obj_controller.cooldown=8000;
        
        // Start battle here
        
        combating=1;
        
        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        // instance_activate_object(battle_object[current_battle]);
        instance_activate_object(pfleet);
        instance_activate_object(obj_star);
        
        instance_create(0,0,obj_fleet);
        obj_fleet.star_name=target.name;
        // 
        obj_fleet.enemy[1]=enemy_fleet[1];
        obj_fleet.enemy_status[1]=-1;
        
        obj_fleet.en_capital[1]=ecap[1];
        obj_fleet.en_frigate[1]=efri[1];
        obj_fleet.en_escort[1]=eesc[1];
        
        // Plug in all of the enemies first
        // And then plug in the allies after then with their status set to positive
        
        if (instance_exists(obj_temp3)){
            obj_fleet.csm_exp=1;
            with(obj_temp3){instance_destroy();}
        }
        if (instance_exists(obj_temp2)){
            obj_fleet.csm_exp=2;
            with(obj_temp2){instance_destroy();}
        }
        
        
        stahr=target;
        if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.Monastery) == 1) then obj_fleet.player_lasers=stahr.p_lasers[1];
        if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.Monastery) == 1) then obj_fleet.player_lasers=stahr.p_lasers[2];
        if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.Monastery) == 1) then obj_fleet.player_lasers=stahr.p_lasers[3];
        if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.Monastery) == 1) then obj_fleet.player_lasers=stahr.p_lasers[4];
        instance_deactivate_object(obj_star);
        
        
        
        
        
        // 
        
        
        var i;i=0;
        repeat(8){
            i+=1;if (pfleet.capital[i]!="") then obj_fleet.fighting[pfleet.capital_num[i]]=1;
        }
        
        i=0;
        repeat(30){
            i+=1;if (pfleet.frigate[i]!="") then obj_fleet.fighting[pfleet.frigate_num[i]]=1;
        }
        
        i=0;
        repeat(30){
            i+=1;if (pfleet.escort[i]!="") then obj_fleet.fighting[pfleet.escort_num[i]]=1;
        }
        
        // instance_deactivate_object(battle_object[current_battle]);
        instance_deactivate_object(pfleet);
        
        
        
        obj_controller.combat=1;
        obj_fleet.player_started=1;
        obj_fleet.pla_fleet=pfleet;
        obj_fleet.ene_fleet=target;
        
        
        
        
    }
}



/* */
}
}
}
/*  */
