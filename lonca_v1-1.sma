/* Bu kod Berat Nzp tarafindan CSxTR.com icin kodlanmistir...
				Iletisim: beratnzp1@gmail.com				*/

#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <cstrike>
#include <fakemeta>
#include <fun>
#include <nvault>
#include <engine>
#include <colorchat>
#include <jail>
#include <csx>

#define PLUGIN "Lonca"
#define VERSION "1.0"
#define AUTHOR "Berat Nzp"

#define RESTART_TASK 123456

new tagplugin[]="^4[^1CSxTR^4]"
new vgoster[]="1.1 Beta"

new loncamevcut[33];
new loncadegistirme[33];
new oyuncupuan[33];
new oyuncuseviye[33];
new yeniayrilma[33];

new lonca1[]="The Rookies" // Caylaklar
new lonca2[]="The Killers" // Katiller
new lonca3[]="The Destroyers" // Yýkýcýlar
new lonca4[]="The Royals" // Kraliyet Ailesi

new lonca1tag[]="TR"
new lonca2tag[]="TK"
new lonca3tag[]="TD"
new lonca4tag[]="***"

new lonca1kayit[33];
new lonca2kayit[33];
new lonca3kayit[33];
new lonca4kayit[33];

//new lonca1seviye=0;
//new lonca2seviye=0;
//new lonca3seviye=0;
//new lonca4seviye=0;

new lonca1puan;
new lonca2puan;
new lonca3puan;
new lonca4puan;

new lonca1mevcut;
new lonca2mevcut;
new lonca3mevcut;
new lonca4mevcut;

new olen;
new olduren;
new headshoot;

new loncadegis;
new killpointsys;
new playerkillpoint;
new playerkillhspoint;
new killpoint;
new killhspoint;
new suicidepoint;

const MENU_TUSLARI = MENU_KEY_0|MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /lonca","loncasys")
	
	loncadegis	= register_cvar("lonca_degis"	, "4")
	killpointsys	= register_cvar("lonca_puan"	, "100")
	
	register_menu("loncasysmenu",MENU_TUSLARI,"loncasysislem")
	register_menu("loncabilgi",MENU_TUSLARI,"loncabilgiislem")
	
	RegisterHam(Ham_Spawn,"player","Fwd_PlayerSpawn_Post",1)
	register_event("DeathMsg","eDeath","a")
	register_event("TextMsg","RestartTask","a","2&#Game_C")
	
	register_clcmd("say artir","artir")
}

public artir(id)
{
	oyuncupuan[id] += 500
}

public client_putinserver(id)
{
	loncamevcut[id]		= 0;
	loncadegistirme[id]	= get_pcvar_num(loncadegis)
	oyuncupuan[id]		= 0;
	oyuncuseviye[id]	= 0;
	yeniayrilma[id]		= 0;
	
	lonca1kayit[id]		= 0;
	lonca2kayit[id]		= 0;
	lonca3kayit[id]		= 0;
	lonca4kayit[id]		= 0;
}

public client_disconnect(client)
{
	if(lonca1kayit[client]==1)
	{
		lonca1mevcut	-=1;
	}
	if(lonca2kayit[client]==1)
	{
		lonca2mevcut	-=1;
	}
	if(lonca3kayit[client]==1)
	{
		lonca3mevcut	-=1;
	}
	if(lonca4kayit[client]==1)
	{
		lonca4mevcut	-=1;
	}
}

public RestartTask()
{
	set_task(3.0,"PuanlariSifirla",RESTART_TASK)
}

public PuanlariSifirla()
{
	lonca1puan	= 0
	lonca2puan	= 0
	lonca3puan	= 0
	lonca4puan	= 0
	ColorChat(0,NORMAL,"%s ^1Lonca puanlari sifirlandi.",tagplugin)
}

public seviyekontrol(id)
{
	if(0<oyuncupuan[id]<1000)
	{
		oyuncuseviye[id] = 0;
	}
	if(1000<=oyuncupuan[id]<2500)
	{
		oyuncuseviye[id] = 1;
	}
	if(2500<=oyuncupuan[id]<4500)
	{
		oyuncuseviye[id] = 2;
	}
	if(4500<=oyuncupuan[id]<7000)
	{
		oyuncuseviye[id] = 3;
	}
	if(7000<=oyuncupuan[id]<10000)
	{
		oyuncuseviye[id] = 4;
	}
	if(10000<=oyuncupuan[id])
	{
		oyuncuseviye[id] = 5;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////
	if(oyuncupuan[id]>=15000)
	{
		oyuncuseviye[id] = 5;
	}
	return PLUGIN_CONTINUE;
}

public eDeath()
{
	olduren = read_data(1);
	olen = read_data(2);
	headshoot = read_data(3);
	
	playerkillpoint		= get_pcvar_num(killpointsys);
	playerkillhspoint	= playerkillpoint/2;
	killpoint		= playerkillpoint+playerkillpoint;
	killhspoint		= playerkillhspoint+playerkillhspoint;
	suicidepoint		= playerkillpoint/4
	new aname[32],bname[32];
	get_user_name(olduren,aname,31);
	get_user_name(olen,bname,31);
	
	seviyekontrol(olduren);
	seviyekontrol(olen);
	
	if(cs_get_user_team(olen)==CS_TEAM_T&&cs_get_user_team(olduren)==CS_TEAM_CT)
	{
		if(loncamevcut[olen]==1)
		{
			if(lonca1kayit[olen]==1)
			{
				lonca1puan	-= suicidepoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kaybettirmistir. Lonca Puanimiz:^4%d",lonca1tag,bname,suicidepoint,lonca1puan);
			}
			if(lonca2kayit[olen]==1)
			{
				lonca2puan	-= suicidepoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kaybettirmistir. Lonca Puanimiz:^4%d",lonca2tag,bname,suicidepoint,lonca2puan);
			}
			if(lonca3kayit[olen]==1)
			{
				lonca3puan	-= suicidepoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kaybettirmistir. Lonca Puanimiz:^4%d",lonca3tag,bname,suicidepoint,lonca3puan);
			}
			if(lonca4kayit[olen]==1)
			{
				lonca4puan	-= suicidepoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kaybettirmistir. Lonca Puanimiz:^4%d",lonca4tag,bname,suicidepoint,lonca4puan);
			}
		}
	}
	
	if(cs_get_user_team(olen)==CS_TEAM_CT)
	{
		if(loncamevcut[olduren]==1)
		{
			if(lonca1kayit[olduren]==1)
			{
				oyuncupuan[olduren]+=playerkillpoint;
				lonca1puan+=killpoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kazandirmistir. Lonca Puanimiz:^4%d",lonca1tag,aname,killpoint,lonca1puan);
				if(headshoot)
				{
					oyuncupuan[olduren]+=playerkillhspoint;
					lonca1puan+=killhspoint;
					ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza +^4%d^1 daha puan kazandirmistir. Lonca Puanimiz:^4%d",lonca1tag,aname,killhspoint,lonca1puan);
				}
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(loncamevcut[olduren]==1)
		{
			if(lonca2kayit[olduren]==1)
			{
				oyuncupuan[olduren]+=playerkillpoint;
				lonca2puan+=killpoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kazandirmistir. Lonca Puanimiz:^4%d",lonca2tag,aname,killpoint,lonca2puan);
				if(headshoot)
				{
					oyuncupuan[olduren]+=playerkillhspoint;
					lonca2puan+=killhspoint;
					ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza +^4%d^1 daha puan kazandirmistir. Lonca Puanimiz:^4%d",lonca2tag,aname,killhspoint,lonca2puan);
				}
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(loncamevcut[olduren]==1)
		{
			if(lonca3kayit[olduren]==1)
			{
				oyuncupuan[olduren]+=playerkillpoint;
				lonca3puan+=killpoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kazandirmistir. Lonca Puanimiz:^4%d",lonca3tag,aname,killpoint,lonca3puan);
				if(headshoot)
				{
					oyuncupuan[olduren]+=playerkillhspoint;
					lonca3puan+=killhspoint;
					ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza +^4%d^1 daha puan kazandirmistir. Lonca Puanimiz:^4%d",lonca3tag,aname,killhspoint,lonca3puan);
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////
		if(loncamevcut[olduren]==1)
		{
			if(lonca4kayit[olduren]==1)
			{
				oyuncupuan[olduren]+=playerkillpoint;
				lonca4puan+=killpoint;
				ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza ^4%d^1 puan kazandirmistir. Lonca Puanimiz:^4%d",lonca4tag,aname,killpoint,lonca4puan);
				if(headshoot)
				{
					oyuncupuan[olduren]+=playerkillhspoint;
					lonca4puan+=killhspoint;
					ColorChat(0,NORMAL,"^4[^1%s^4] ^3%s^1 loncamiza +^4%d^1 daha puan kazandirmistir. Lonca Puanimiz:^4%d",lonca4tag,aname,killhspoint,lonca4puan);
				}
			}
		}
		loncasys(olduren);
	}
}

public Fwd_PlayerSpawn_Post(id)
{
	if(cs_get_user_team(id)==CS_TEAM_CT)
	{
		loncamevcut[id]		= 0;
		loncadegistirme[id]	= get_pcvar_num(loncadegis)
		//oyuncupuan[id]		= 0;
		yeniayrilma[id]		= 0;
		
		if(lonca1kayit[id]==1)
		{
			lonca1kayit[id]	= 0;
			lonca1mevcut	-= 1;
		}
		if(lonca2kayit[id]==1)
		{
			lonca2kayit[id]	= 0;
			lonca2mevcut	-= 1;
		}
		if(lonca3kayit[id]==1)
		{
			lonca3kayit[id]	= 0;
			lonca3mevcut	-= 1;
		}
		if(lonca4kayit[id]==1)
		{
			lonca4kayit[id]	= 0;
			lonca4mevcut	-= 1;
		}
	}
	
	if(loncamevcut[id]<1&&cs_get_user_team(id)==CS_TEAM_T)
	{
		ColorChat(id,NORMAL,"%s ^1Hicbir loncada bulunmadiginiz icin extra ozellikler gelmedi. Loncalara katilmak icin ^3^"/lonca^"^1 yazin.",tagplugin);
	}
	
	if(loncamevcut[id]==1)
	{
		seviyekontrol(id);
		set_task(2.5,"seviye_ayar",id);
	}
}

public seviye_ayar(id)
{
	if(lonca1kayit[id]==1)
	{
		if(oyuncuseviye[id]==1)
		{
			set_user_health(id,105);
		}
		if(oyuncuseviye[id]==2)
		{
			set_user_health(id,1110);
		}
		if(oyuncuseviye[id]==3)
		{
			set_user_health(id,115);
		}
		if(oyuncuseviye[id]==4)
		{
			set_user_health(id,120);
		}
		if(oyuncuseviye[id]==5)
		{
			set_user_health(id,125);
		}
	}

	if(lonca2kayit[id]==1)
	{
		if(oyuncuseviye[id]==1)
		{
			set_user_maxspeed(id,275.0);
		}
		if(oyuncuseviye[id]==2)
		{
			set_user_maxspeed(id,300.0);
		}
		if(oyuncuseviye[id]==3)
		{
			set_user_maxspeed(id,325.0);
		}
		if(oyuncuseviye[id]==4)
		{
			set_user_maxspeed(id,350.0);
		}
		if(oyuncuseviye[id]==5)
		{
			set_user_maxspeed(id,375.0);
		}
	}
	
	if(lonca3kayit[id]==1)
	{
		if(oyuncuseviye[id]==1)
		{
			set_user_gravity(id,0.9)
		}
		if(oyuncuseviye[id]==2)
		{
			set_user_gravity(id,0.8)
		}
		if(oyuncuseviye[id]==3)
		{
			set_user_gravity(id,0.7)
		}
		if(oyuncuseviye[id]==4)
		{
			set_user_gravity(id,0.6)
		}
		if(oyuncuseviye[id]==5)
		{
			set_user_gravity(id,0.5)
		}
	}
	if(lonca4kayit[id]==1)
	{
			set_user_health(id,125);
			set_user_maxspeed(id,375.0);
			set_user_gravity(id,0.5);
	}
}

public loncasys(id)
{
	if(cs_get_user_team(id)==CS_TEAM_T)
	{
		new pname[32];
		get_user_name(id,pname,31);
		static MenuSys1[512],satir;
		satir=0;
		
		satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\d. :\wLonca \r%s\d: . (csxtr.com)^n",vgoster);
		satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rMerhaba; \d%s^n",pname);
		satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rSeviyeniz: \d%d^n",oyuncuseviye[id]);
		satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rTecrube Puaniniz: \d%d^n",oyuncupuan[id]);
		
		if(loncamevcut[id]==0)
		{
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\wLoncaniz yok. Lonca Secin;^n");
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w1. \y%s \d(Mevut: %d - Puan: %d)^n",lonca1,lonca1mevcut,lonca1puan);
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w2. \y%s \d(Mevut: %d - Puan: %d)^n",lonca2,lonca2mevcut,lonca2puan);
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w3. \y%s \d(Mevut: %d - Puan: %d)^n",lonca3,lonca3mevcut,lonca3puan);
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w4. \y%s \d(Mevut: %d - Puan: %d)^n",lonca4,lonca4mevcut,lonca4puan);
		}
		
		if(loncamevcut[id]==1)
		{
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(lonca1kayit[id]==1)
			{
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLoncaniz: \d%s (%d)^n",lonca1,lonca1mevcut);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rOzellik: \yHP^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLonca Puani: \y%d^n",lonca1puan);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(lonca2kayit[id]==1)
			{
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLoncaniz: \d%s (%d)^n",lonca2,lonca2mevcut);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rOzellik: \ySpeed^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLonca Puani: \y%d^n",lonca2puan);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(lonca3kayit[id]==1)
			{
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLoncaniz: \d%s (%d)^n",lonca3,lonca3mevcut);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rOzellik: \yGravity^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLonca Puani: \y%d^n",lonca3puan);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(lonca4kayit[id]==1)
			{
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLoncaniz: \d%s (%d)^n",lonca4,lonca4mevcut);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rOzellik: \yHP + Speed + Gravity^n");
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\rLonca Puani: \y%d^n",lonca4puan);
				satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w8. \yLoncalari goster^n");
			satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w9. \yLoncadan Ayril^n");
		}
		satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"^n");
		satir+=formatex(MenuSys1[satir],charsmax(MenuSys1)-satir,"\w0. Kapat");
		show_menu(id,MENU_TUSLARI,MenuSys1,-1,"loncasysmenu");
	}
	return PLUGIN_HANDLED;
}


public loncasysislem(id,bind1)
{
	new pname[32];
	get_user_name(id,pname,31);
	switch(bind1)
	{
		case 0:
		{
			if(loncamevcut[id]<1&&loncadegistirme[id]>=1)
			{
				loncamevcut[id]		= 1;
				loncadegistirme[id]	-=1;
				yeniayrilma[id]		= 0;
				
				lonca1kayit[id]		= 1;
				lonca1mevcut		+=1;
				lonca2kayit[id]		= 0;
				lonca3kayit[id]		= 0;
				lonca4kayit[id]		= 0;
				
				ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasina katildi !",tagplugin,pname,lonca1);
				loncasys(id);
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(loncadegistirme[id]<1)
			{
				ColorChat(id,NORMAL,"%s ^1En fazla ^4%d^1 defa lonca degistirebilirsiniz.",get_pcvar_num(loncadegis))
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		case 1:
		{
			if(loncamevcut[id]<1&&loncadegistirme[id]>=1)
			{
				loncamevcut[id]		= 1;
				loncadegistirme[id]	-=1;
				yeniayrilma[id]		= 0;
				
				lonca1kayit[id]		= 0;
				lonca2kayit[id]		= 1;
				lonca2mevcut		+=1;
				lonca3kayit[id]		= 0;
				lonca4kayit[id]		= 0;
				
				ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasina katildi !",tagplugin,pname,lonca2);
				loncasys(id);
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(loncadegistirme[id]<1)
			{
				ColorChat(id,NORMAL,"%s ^1En fazla ^4%d^1 defa lonca degistirebilirsiniz.",get_pcvar_num(loncadegis))
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		case 2:
		{
			if(loncamevcut[id]<1&&loncadegistirme[id]>=1)
			{
				loncamevcut[id]		= 1;
				loncadegistirme[id]	-=1;
				yeniayrilma[id]		= 0;
				
				lonca1kayit[id]		= 0;
				lonca2kayit[id]		= 0;
				lonca3kayit[id]		= 1;
				lonca3mevcut		+=1;
				lonca4kayit[id]		= 0;
				
				ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasina katildi !",tagplugin,pname,lonca3);
				loncasys(id);
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(loncadegistirme[id]<1)
			{
				ColorChat(id,NORMAL,"%s ^1En fazla ^4%d^1 defa lonca degistirebilirsiniz.",get_pcvar_num(loncadegis))
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		case 3:
		{
			if(loncamevcut[id]<1&&loncadegistirme[id]>=1&&oyuncupuan[id]>=15000)
			{
				loncamevcut[id]		= 1;
				loncadegistirme[id]	-=1;
				yeniayrilma[id]		= 0;
				
				lonca1kayit[id]		= 0;
				lonca2kayit[id]		= 0;
				lonca3kayit[id]		= 0;
				lonca4kayit[id]		= 1;
				lonca4mevcut		+=1;
				
				ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasina katildi !",tagplugin,pname,lonca4);
				loncasys(id);
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			if(loncadegistirme[id]<1)
			{
				ColorChat(id,NORMAL,"%s ^1En fazla ^4%d^1 defa lonca degistirebilirsiniz.",get_pcvar_num(loncadegis));
			}
			if(oyuncupuan[id]<25000)
			{
				ColorChat(id,NORMAL,"%s Loncamiza katilabilmek icin en az^3 15.000 TP^1'niz olmalidir.",tagplugin);
			}
		}
		case 7:
		{
			loncabilgi(id);
		}
		case 8:
		{
			if(loncamevcut[id]==1)
			{
				loncaayril(id);
				loncasys(id);
			}
		}
	}
}

public loncaayril(id)
{
	new pname[32];
	get_user_name(id,pname,31);
	if(loncamevcut[id]==1)
	{
		if(lonca1kayit[id]==1)
		{
			lonca1kayit[id]		= 0;
			loncamevcut[id]		= 0;
			yeniayrilma[id]		= 1;
			lonca1mevcut		-=1;
			ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasindan ayrildi !",tagplugin,pname,lonca1);

		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(lonca2kayit[id]==1)
		{
			lonca2kayit[id]		= 0;
			loncamevcut[id]		= 0;
			yeniayrilma[id]		= 1;
			lonca2mevcut		-=1;
			ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasindan ayrildi !",tagplugin,pname,lonca2);

		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(lonca3kayit[id]==1)
		{
			lonca3kayit[id]		= 0;
			loncamevcut[id]		= 0;
			yeniayrilma[id]		= 1;
			lonca3mevcut		-=1;
			ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasindan ayrildi !",tagplugin,pname,lonca3);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(lonca4kayit[id]==1)
		{
			lonca4kayit[id]		= 0;
			loncamevcut[id]		= 0;
			yeniayrilma[id]		= 1;
			lonca4mevcut		-=1;
			ColorChat(0,NORMAL,"%s ^3%s^1 nickli oyuncu ^3%s^1 loncasindan ayrildi !",tagplugin,pname,lonca4);
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////
	if(loncamevcut[id]==0&&yeniayrilma[id]==0)
	{
		ColorChat(id,NORMAL,"%s Zaten hicbir loncada degilsiniz.",tagplugin);
	}
	return PLUGIN_HANDLED;
}

public loncabilgi(id)
{
	new pname[32];
	get_user_name(id,pname,31);
	if(loncamevcut[id]==1)
	{
		static MenuSys2[512],satirx;
		satirx=0;
		
		satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\d. :\wLonca \r%s\d: .^n",vgoster);
		satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\rMerhaba; \d%s^n",pname);
		
		satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"^n");
		if(lonca1kayit[id]==0)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w1. \d%s \d(Mevut: %d - Puan: %d)^n",lonca1,lonca1mevcut,lonca1puan);
		}
		if(lonca1kayit[id]==1)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w1. \y%s \d(Mevut: %d - Puan: %d)^n",lonca1,lonca1mevcut,lonca1puan);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(lonca2kayit[id]==0)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w2. \d%s \d(Mevut: %d - Puan: %d)^n",lonca2,lonca2mevcut,lonca2puan);
		}
		if(lonca2kayit[id]==1)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w2. \y%s \d(Mevut: %d - Puan: %d)^n",lonca2,lonca2mevcut,lonca2puan);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(lonca3kayit[id]==0)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w3. \d%s \d(Mevut: %d - Puan: %d)^n",lonca3,lonca3mevcut,lonca3puan);
		}
		if(lonca3kayit[id]==1)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w3. \y%s \d(Mevut: %d - Puan: %d)^n",lonca3,lonca3mevcut,lonca3puan);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		if(lonca4kayit[id]==0)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w4. \d%s \d(Mevut: %d - Puan: %d)^n",lonca4,lonca4mevcut,lonca4puan);
		}
		if(lonca4kayit[id]==1)
		{
			satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w4. \y%s \d(Mevut: %d - Puan: %d)^n",lonca4,lonca4mevcut,lonca4puan);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"^n");
		satirx+=formatex(MenuSys2[satirx],charsmax(MenuSys2)-satirx,"\w0. Kapat");
		show_menu(id,MENU_TUSLARI,MenuSys2,-1,"loncabilgimenu");
	}
	return PLUGIN_HANDLED;
}

public loncabilgiislem(id,bind2)
{
	switch(bind2)
	{
		case 0:
		{
			loncabilgi(id);
		}
		case 1:
		{
			loncabilgi(id);
		}
		case 2:
		{
			loncabilgi(id);
		}
		case 3:
		{
			loncabilgi(id);
		}
	}
}
