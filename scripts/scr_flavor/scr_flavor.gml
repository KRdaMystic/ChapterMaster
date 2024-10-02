function scr_flavor(id_of_attacking_weapons, target, target_type, number_of_shots, casulties) {

	// Generates flavor based on the damage and casualties from scr_shoot, only for the player

	targeh = target_type;
	var p1, p2, mes, targeh;
	mes = "";
	p1 = $"";
	p2 = "";

	var weapon_name = "";
	if (id_of_attacking_weapons > 0) {
		weapon_name = wep[id_of_attacking_weapons];
	}
	if (id_of_attacking_weapons = -51) then weapon_name = "Heavy Bolter Emplacemelse ent";
	if (id_of_attacking_weapons = -52) then weapon_name = "Missile Launcher Emplacement";
	if (id_of_attacking_weapons = -53) then weapon_name = "Missile Silo";

	var weapon_data = gear_weapon_data("weapon", weapon_name, "all");
	if (!is_struct(weapon_data)) {
		weapon_data = new equipment_struct({},"");
		weapon_data.name = weapon_name;
	}

	var target_name = target.dudes[targeh];

	if (target_name = "Leader") and (obj_ncombat.enemy <= 10) {
		target_name = obj_controller.faction_leader[obj_ncombat.enemy];
	}
	var character_shot = false,
		full_name = "",
		cm_kill = 0;

	if (id_of_attacking_weapons > 0) {
		if (array_length(wep_solo[id_of_attacking_weapons]) > 0) {
			character_shot = true;
			full_names = wep_solo[id_of_attacking_weapons];
			if (wep_title[id_of_attacking_weapons] != "") {
				if (array_length(full_names) == 1) {
					full_name = wep_title[id_of_attacking_weapons] + " " + wep_solo[id_of_attacking_weapons][0];
				} else {
					full_name = wep_title[id_of_attacking_weapons] + "'s"
				}
			}
			if (wep_solo[id_of_attacking_weapons][0] == obj_ini.master_name) then cm_kill = 1;
		}
	}

	if (obj_ncombat.battle_special = "WL10_reveal") or (obj_ncombat.battle_special = "WL10_later") {
		if (target_name = "Veteran Chaos Terminator") and (target_name > 0) then obj_ncombat.chaos_angry += casulties * 2;
		if (target_name = "Veteran Chaos Chosen") and (target_name > 0) then obj_ncombat.chaos_angry += casulties;
		if (target_name = "Greater Daemon of Slaanesh") then obj_ncombat.chaos_angry += casulties * 5;
		if (target_name = "Greater Daemon of Tzeentch") then obj_ncombat.chaos_angry += casulties * 5;
	}

	if (target.flank = 1) and (target.flyer = 0) then target_name = "flanking " + target_name;

	var flavoured = false;

	if (weapon_data.has_tag("bolt")) {
		flavoured = true;
		if (!character_shot) {
			if (obj_ncombat.bolter_drilling == 1) {
				p1 += "With perfect accuracy ";
			}
			if (number_of_shots < 200) {
				if (target.dudes_num[targeh] == 1) {
					if (casulties == 0) {
						p1 += $"{number_of_shots} {weapon_name}s fire. The {target_name} is hit but survives.";
					} else {
						p1 += $"{number_of_shots} {weapon_name}s fire. The {target_name} is struck down.";
					}
				} else {
					if (casulties == 0) {
						p1 += $"{number_of_shots} {weapon_name}s fire hits {target_name} ranks without causing casualties.";
					} else {
						p1 += $"{number_of_shots} {weapon_name}s strike {target_name} ranks, taking down {casulties}.";
					}
				}
			} else {
				if (target.dudes_num[targeh] == 1) {
					if (casulties == 0) {
						p1 += $"{number_of_shots} {weapon_name}s fire. Explosions rock the {target_name}'s armour but don't kill it.";
					} else {
						p1 += $"{number_of_shots} {weapon_name}s fire. Explosions take down the {target_name}.";
					}
				} else {
					if (casulties == 0) {
						p1 += $"{number_of_shots} {weapon_name}s hit {target_name} ranks, but no casualties are confirmed.";
					} else {
						p1 += $"{number_of_shots} {weapon_name}s tear through {target_name} ranks, instantly killing {casulties}.";
					}
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 += $"{string(full_name)} fires his {weapon_name} at the {target_name} but fails to kill it.";
				} else {
					p1 += $"{string(full_name)} eliminates the {target_name} with his {weapon_name}.";
				}
			} else {
				if (casulties == 0) {
					p1 += $"{string(full_name)} fires his {weapon_name} at {target_name} ranks but fails to kill any.";
				} else {
					p1 += $"{string(full_name)} takes down {casulties} {target_name} with his {weapon_name}.";
				}
			}
		}

	} else if (weapon_name == "hammer_of_wrath") {
		flavoured = true;
		if (!character_shot) {
			if (number_of_shots < 20) {
				p1 += $"{number_of_shots} Astartes with Jump Packs soar upwards, flames roaring. They plummet back down upon the enemy- ";
			} else if (number_of_shots >= 20 && number_of_shots < 100) {
				p1 += $"Squads of Astartes ascend with roaring Jump Packs. They descend upon the enemy- ";
			} else {
				p1 += $"A massive wave of Astartes rise, their Jump Packs a furious beast. They crash down, smashing their foe- ";
			}
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 += $"but the {target_name} endures the onslaught.";
				} else {
					p1 += $"the {target_name} falls to the charge.";
				}
			} else {
				if (casulties == 0) {
					p1 += $"{target_name} ranks are hit, but no casualties are confirmed.";
				} else {
					p1 += $"{target_name} ranks are hit, killing {casulties} in an instant.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				p1 += string(full_name) + $" engages his Jump Pack, soaring and crashing into the {target_name}- ";
				if (casulties == 0) {
					p1 += $"but it endures the onslaught.";
				} else {
					p1 += $"and it falls to the charge.";
				}
			} else {
				p1 += string(full_name) + $" activates his Jump Pack, slamming into {target_name} ranks- ";
				if (casulties == 0) {
					p1 += $"but all survive the impact.";
				} else {
					p1 += $"killing {casulties} perish in the attack.";
				}
			}
		}

	} else if (weapon_name == "Assault Cannon") {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 += $"{number_of_shots} {weapon_name}s roar, explosions clap across the armour of the {target_name} but it remains standing.";
				} else {
					p1 += $"{number_of_shots} {weapon_name}s fire at the {target_name} and rip it apart.";
				}
			} else {
				if (casulties == 0) {
					p1 += $"{number_of_shots} {weapon_name}s thunder, {target_name} are rocked but unharmed.";
				} else {
					p1 += $"{number_of_shots} {weapon_name}s mow down {casulties} {target_name}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 += $"{string(full_name)} {weapon_name} fires but the {target_name} survives.";
				} else {
					p1 += $"{string(full_name)} obliterates the {target_name} with the {weapon_name}.";
				}
			} else {
				if (casulties == 0) {
					p1 += $"{string(full_name)} {weapon_name} fails to breach {target_name} ranks.";
				} else {
					p1 += $"{string(full_name)} cuts down {casulties} {target_name} with the {weapon_name}.";
				}
			}
		}

	} else if (weapon_name == "Missile Launcher") {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 = $"{number_of_shots} {weapon_name}s fire upon the {target_name} but it remains standing.";
				} else {
					p1 = $"{number_of_shots} {weapon_name}s blast the {target_name} to oblivion.";
				}
			} else {
				if (casulties == 0) {
					p1 = $"{number_of_shots} {weapon_name}s hit {target_name} ranks but they hold firm.";
				} else {
					p1 = $"{number_of_shots} {weapon_name}s pulverize {casulties} {target_name}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 = $"{string(full_name)} {weapon_name} fires upon the {target_name} but it survives.";
				} else {
					p1 = $"{string(full_name)} obliterates {target_name} with the {weapon_name}.";
				}
			} else {
				if (casulties == 0) {
					p1 = $"{string(full_name)} {weapon_name} fails to inflict damage upon {target_name} ranks.";
				} else {
					p1 = $"{string(full_name)} pulverizes {casulties} {target_name} with the {weapon_name}.";
				}
			}
		}

	} else if (weapon_name == "Whirlwind Missiles") {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 = $"{number_of_shots} Whirlwinds fire upon the {target_name} but it remains standing.";
				} else {
					p1 = $"{number_of_shots} Whirlwinds blast {target_name} to oblivion.";
				}
			} else {
				if (casulties == 0) {
					p1 = $"{number_of_shots} Whirlwinds hit {target_name} ranks but they hold firm.";
				} else {
					p1 = $"{number_of_shots} Whirlwinds pulverize {casulties} {target_name}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 = $"Whirlwind fires upon the {target_name} but it survives.";
				} else {
					p1 = $"Whirlwind obliterates the {target_name}.";
				}
			} else {
				if (casulties == 0) {
					p1 = $"Whirlwind fails to inflict damage upon {target_name} ranks.";
				} else {
					p1 = $"Whirlwind pulverizes {casulties} {target_name}.";
				}
			}
		}

	} else if (weapon_name == "fists") or (weapon_name == "Melee") or (weapon_name == "melee") {
		flavoured = true;
		var ra = choose(1, 2, 3, 4);
		// This needs to be worked out
		if (casulties = 0) then p1 = $"{target_name} engaged in hand-to-hand combat, no casualties.";
		if (casulties > 0) {
			p1 = $"{target_name} ranks ";
			if (ra = 1) then p1 = "are struck with gun-barrels and fists.";
			if (ra = 2) then p1 = "are savaged by your marines in hand-to-hand combat.";
			if (ra = 3) then p1 = "are smashed by your marines.";
			if (ra = 4) then p1 = "are struck by your marines in melee.";
		}

	} else if (weapon_name = "Force Staff") {
		flavoured = true;
		if (number_of_shots = 1) then p1 = $"{target_name} is blasted by the {weapon_name}.";
		if (number_of_shots > 1) then p1 = $"{number_of_shots} {weapon_name} crackle and swing into the {target_name} ranks, killing {casulties}.";

	} else if (weapon_data.has_tag("plasma")) {
		flavoured = true;
		if (target.dudes_num[targeh] = 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} shoot bolts of energy into a {target_name}, failing to kill it.";
		if (target.dudes_num[targeh] = 1) and (casulties = 1) then p1 = $"{number_of_shots} {weapon_name} overwhelm a {target_name} with bolts of energy, killing {casulties}.";
		if (target.dudes_num[targeh] > 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} shoot bolts of energy into the {target_name} ranks, failing to kill any.";
		if (target.dudes_num[targeh] > 1) and (casulties > 0) then p1 = $"{number_of_shots} {weapon_name} shoot bolts of energy into the {target_name}, cleansing {casulties}.";

	} else if (weapon_data.has_tag("flame")) {
		flavoured = true;
		if (target.dudes_num[targeh] = 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} bathe the {target_name} in holy promethium, failing to kill it.";
		if (target.dudes_num[targeh] = 1) and (casulties = 1) then p1 = $"{number_of_shots} {weapon_name} flash-fry the {target_name} inside its armour, inflicting {casulties}.";
		if (target.dudes_num[targeh] > 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} wash over the {target_name} ranks, failing to kill any.";
		if (target.dudes_num[targeh] > 1) and (casulties > 0) then p1 = $"{number_of_shots} {weapon_name} bathe the {target_name} ranks in holy promethium, cleansing {casulties}.";

	} else if (weapon_name = "Webber") {
		flavoured = true;
		if ((target_name = "Termagaunt") or (target_name = "Hormagaunt")) and (casulties > 0) then obj_ncombat.captured_gaunt += casulties;
		if (target.dudes_num[targeh] = 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} but fail to immobilize it.";
		if (target.dudes_num[targeh] = 1) and (casulties = 1) then p1 = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} and fully immobilize it.";
		if (target.dudes_num[targeh] > 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} ranks, failing to immobilize any.";
		if (target.dudes_num[targeh] > 1) and (casulties > 0) then p1 = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} ranks and immobilize {casulties} of them.";

	} else if (weapon_name = "Close Combat Weapon") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then p1 = $"{target_name} is struck by " + string(obj_ini.role[100][6]) + " but survives.";
		if (number_of_shots = 1) and (casulties = 1) then p1 = $"{target_name} is struck down by " + string(obj_ini.role[100][6]) + ".";
		if (number_of_shots > 1) and (casulties = 0) then p1 = $"{number_of_shots} {string(obj_ini.role[100][6])}s wrench and smash at {target_name} but fail to destroy it.";
		if (number_of_shots > 1) and (casulties > 1) then p1 = $"{number_of_shots} {string(obj_ini.role[100][6])}s stomp, wrench, and smash {casulties} {target_name} into paste.";

	} else if (weapon_name = "Chainsword") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then p1 = $"{target_name} is struck by a {weapon_name} but survives.";
		if (number_of_shots = 1) and (casulties = 1) then p1 = $"{target_name} is cut down by a {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then p1 = $"{number_of_shots} motors rev and hack at the {target_name} ranks, but don't kill any.";
		if (number_of_shots > 1) and (casulties > 0) then p1 = $"{number_of_shots} motors rev and hack away at the {target_name} ranks. {casulties} are cut down.";

	} else if (weapon_name = "Sarissa") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then p1 = $"A {target_name} is struck by a Battle Sister's {weapon_name} but survives.";
		if (number_of_shots = 1) and (casulties = 1) then p1 = $"A {target_name} is struck down by a Battle Sister's {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then p1 = $"Battle Sisters " + choose("howl out", "roar") + $" and hack at {target_name} ranks with their {weapon_name}s, but they survive.";
		if (number_of_shots > 1) and (casulties > 0) then p1 = $"{number_of_shots} Battle Sisters " + choose("howl out", "roar") + $" as they hack away at the {target_name} ranks, killing {casulties} with their {weapon_name}s.";

	} else if (weapon_name = "Eviscerator") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then p1 = $"A {target_name} is struck by a {weapon_name} but survives.";
		if (number_of_shots = 1) and (casulties = 1) then p1 = $"A {target_name} is cut down by a {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name} rev and howl, hacking at the {target_name} ranks, failing to kill any.";
		if (number_of_shots > 1) and (casulties > 0) then p1 = $"{number_of_shots} {weapon_name} rev and howl, hacking at the {target_name} ranks, {casulties} are cut down.";

	} else if (weapon_name = "Dozer Blades") {
		flavoured = true;
		if (number_of_shots = 1) and (casulties = 0) then p1 = $"A {target_name} is rammed but survives.";
		if (number_of_shots = 1) and (casulties = 1) then p1 = $"A {target_name} is splattered by {weapon_name}.";
		if (number_of_shots > 1) and (casulties = 0) then p1 = $"{weapon_name} ploughs {target_name} ranks , inflicting {casulties}.";
		if (number_of_shots > 1) and (casulties > 0) then p1 = $"{weapon_name} hits {target_name} ranks , inflicting {casulties}.  " + string(casulties) + " are smashed.";

	} else if (weapon_data.has_tag("power")) {
		flavoured = true;
		if (target.dudes_num[targeh] = 1) {
			if (number_of_shots = 1) and (casulties = 0) then p1 = $"A {target_name} is struck by a {weapon_name} but survives.";
			if (number_of_shots = 1) and (casulties = 1) then p1 = $"A {target_name} is struck down by a {weapon_name}.";

			if (number_of_shots > 1) and (casulties = 0) then p1 = $"A {target_name} is struck by {number_of_shots} {weapon_name}s but survives.";
			if (number_of_shots > 1) and (casulties = 1) then p1 = $"A {target_name} is struck down by {number_of_shots} {weapon_name}s.";
		}
		if (target.dudes_num[targeh] > 1) {
			if (number_of_shots > 1) and (casulties = 0) then p1 = $"{number_of_shots} {weapon_name}s crackle and spark, striking at the {target_name} ranks, inflicting no damage.";
			if (number_of_shots > 1) and (casulties > 0) then p1 = $"{number_of_shots} {weapon_name}s crackle and spark, hewing through the {target_name} ranks, {casulties} are cut down.";
		}
	}

	// A fallback flavour
	if (flavoured == false) {
		flavoured = true;
		if (!character_shot) {
			if (target.dudes_num[targeh] == 1) {
				if (number_of_shots == 1 && casulties == 0) {
					p1 = $"A {target_name} is struck by {weapon_name} but survives.";
				} else if (number_of_shots == 1 && casulties == 1) {
					p1 = $"A {target_name} is struck down by {weapon_name}.";
				} else if (number_of_shots > 1 && casulties == 0) {
					p1 = $"A {target_name} is struck by {number_of_shots} {weapon_name}s but survives.";
				} else if (number_of_shots > 1 && casulties == 1) {
					p1 = $"A {target_name} is struck down by {number_of_shots} {weapon_name}s.";
				}
			} else {
				if (number_of_shots == 1 && casulties == 0) {
					p1 = $"{weapon_name} strikes at {target_name} but they survive.";
				} else if (number_of_shots == 1 && casulties > 0) {
					p1 = $"{weapon_name} strikes at {target_name} and kills {casulties}";
				} else if (number_of_shots > 1 && casulties == 0) {
					p1 = $"{number_of_shots} {weapon_name}s strike at the {target_name} ranks, but fail to inflict damage.";
				} else if (number_of_shots > 1 && casulties > 0) {
					p1 = $"{number_of_shots} {weapon_name}s strike at the {target_name} ranks, killing {casulties}.";
				}
			}
		} else {
			if (target.dudes_num[targeh] == 1) {
				if (casulties == 0) {
					p1 = $"{string(full_name)} {weapon_name} strikes at a {target_name} but fails to kill it.";
				} else {
					p1 = $"{string(full_name)} {weapon_name} strikes at a {target_name}, killing it.";
				}
			} else {
				if (casulties == 0) {
					p1 = $"{string(full_name)} {weapon_name} strikes at the {target_name} ranks, failing to kill any.";
				} else {
					p1 = $"{string(full_name)} {weapon_name} strikes at the {target_name} ranks and kills {casulties}.";
				}
			}
		}
	}

	// if (string_length(p1+p2+p3)<8) then show_message(weapon_name+" is not displaying anything");

	// When special units get killed
	if (obj_ncombat.dead_enemies != 0){
		for (var i = 0; i <= array_length_1d(obj_ncombat.dead_ene); i++) {
			if (obj_ncombat.dead_ene[i] != "") {
				if (obj_ncombat.dead_enemies == 1) {
					p2 += obj_ncombat.dead_ene[i] + " has been eliminated.";
				} else if (obj_ncombat.dead_enemies == 2) {
					if (i == 0) {
						p2 += obj_ncombat.dead_ene[i] + " and ";
					} else {
						p2 += obj_ncombat.dead_ene[i] + " have been eliminated.";
					}
				} else if (obj_ncombat.dead_enemies > 2) {
					if (i == 0) {
						p2 += obj_ncombat.dead_ene[i] + ", ";
					} else if (i == obj_ncombat.dead_enemies - 1) {
						p2 += "and " + obj_ncombat.dead_ene[i] + " have been eliminated.";
					} else {
						p2 += obj_ncombat.dead_ene[i] + ", ";
					}
				}
			}
			obj_ncombat.dead_ene[i] = "";
		}
		obj_ncombat.dead_enemies = 0;
	}

	mes = p1 + "\n " + p2;

	var led = 0;
	if (wep[id_of_attacking_weapons] == "hammer_of_wrath") then led = 2.1;
	if (obj_ncombat.enemy <= 10) {
		if (target_name = obj_controller.faction_leader[obj_ncombat.enemy]) { // Cleaning up the message for the enemy leader
			mes = string_replace(mes, "a " + target_name, target_name);
			mes = string_replace(mes, "the " + target_name, target_name);
			mes = string_replace(mes, target_name + " ranks , inflicting {casulties}", target_name);
			if (enemy = 5) then mes = string_replace(mes, "it", "her");
			if (enemy = 6) and (obj_controller.faction_gender[6] = 1) then mes = string_replace(mes, "it", "him");
			if (enemy = 6) and (obj_controller.faction_gender[6] = 2) then mes = string_replace(mes, "it", "her");
			if (enemy != 6) and (enemy != 5) then mes = string_replace(mes, "it", "him");
			led = 5;
		}
	}

	if (mes != "") {
		obj_ncombat.messages += 1;
		obj_ncombat.message[obj_ncombat.messages] = mes;

		// show_message("Added to message slot: "+string(obj_ncombat.messages)+"#"+string(mes));
		// show_message(string(obj_ncombat.message[obj_ncombat.messages]));

		if (target.dudes_vehicle[targeh] = 1) then obj_ncombat.message_sz[obj_ncombat.messages] = max(number_of_shots, casulties * 10) + (0.5 - (obj_ncombat.messages / 100));
		else {
			obj_ncombat.message_sz[obj_ncombat.messages] = max(number_of_shots, casulties) + (0.5 - (obj_ncombat.messages / 100));
		}

		obj_ncombat.message_priority[obj_ncombat.messages] = led;
		if (defenses = 1) then obj_ncombat.message_priority[obj_ncombat.messages] += 3;

		obj_ncombat.alarm[3] = 2;
		// need some method of determining who is firing
	}

}