package ddt.data.player
{
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.GameEvent;
   import ddt.events.WebSpeedEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import gemstone.info.GemstonInitInfo;
   import giftSystem.data.MyGiftCellInfo;
   import pet.date.PetInfo;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import store.data.StoreEquipExperience;
   import store.view.embed.EmbedUpLevelCell;
   import totem.TotemManager;
   import trainer.controller.NewHandGuideManager;
   
   public class PlayerInfo extends BasePlayer
   {
      
      public static const SEX:String = "Sex";
      
      public static const STYLE:String = "Style";
      
      public static const HIDE:String = "Hide";
      
      public static const SKIN:String = "Skin";
      
      public static const COLORS:String = "Colors";
      
      public static const NIMBUS:String = "Nimbus";
      
      public static const GOLD:String = "Gold";
      
      public static const MONEY:String = "Money";
      
      public static const DDT_MONEY:String = "Money";
      
      public static const BandMONEY:String = "BandMoney";
      
      public static const PETSCORE:String = "PetScore";
      
      public static const Energy:String = "Energy";
      
      public static const BuyEnergyCount:String = "BuyEnergyCount";
      
      public static const ARM:String = "WeaponID";
      
      public static const UPDATE_SHOP_FINALLY_TIME:String = "shopFinallyGottenTime";
      
      public static const CHARM_LEVEL_NEED_EXP:Array = [0,10,50,120,210,320,450,600,770,960,1170,1410,1680,1980,2310,2670,3060,3480,3930,4410,4920,5470,6060,6690,7360,8070,8820,9610,10440,11310,12220,13190,14220,15310,16460,17670,18940,20270,21660,23110,25110,27660,30760,34410,38610,43360,48660,54510,60910,67860,75360,83460,92160,101460,111360,121860,132960,144660,156960,169860,183360,197460,212160,227460,243360,259860,276960,294660,312960,331860,351360,371460,392160,413460,435360,457860,480960,504660,528960,553860,579360,605460,632160,659460,687360,715860,744960,774660,804960,835860,867360,899460,932160,965460,999360,1033860,1068960,1104660,1140960,1177860];
      
      public static const CHARM_LEVEL_ALL_EXP:Array = [0,10,60,180,390,710,1160,1760,2530,3490,4660,6070,7750,9730,12040,14710,17770,21250,25180,29590,34510,39980,46040,52730,60090,68160,76980,86590,97030,108340,120560,133750,147970,163280,179740,197410,216350,236620,258280,281390,306500,334160,364920,399330,437940,481300,529960,584470,645380,713240,788600,872060,964220,1065680,1177040,1298900,1431860,1576520,1733480,1903340,2086700,2284160,2496320,2723780,2967140,3227000,3503960,3798620,4111580,4443440,4794800,5166260,5558420,5971880,6407240,6865100,7346060,7850720,8379680,8933540,9512900,10118360,10750520,11409980,12097340,12813200,13558160,14332820,15137780,15973640,16841000,17740460,18672620,19638080,20637440,21671300,22740260,23844920,24985880,26163740];
      
      public static const MAX_CHARM_LEVEL:int = 100;
      
      public var signMsg:String = "";
      
      private var _lastLuckNum:int;
      
      private var _luckyNum:int;
      
      private var _lastLuckyNumDate:Date;
      
      private var _attachtype:int = -1;
      
      private var _attachvalue:int;
      
      private var _hide:int;
      
      private var _hidehat:Boolean;
      
      private var _hideGlass:Boolean = false;
      
      private var _suitesHide:Boolean = false;
      
      private var _showSuits:Boolean = true;
      
      private var _wingHide:Boolean = false;
      
      private var _nimbus:int;
      
      private var _modifyStyle:String;
      
      private var _style:String;
      
      private var _tutorialProgress:int;
      
      private var _colors:String = "|,|,,,,||,,,,";
      
      private var _intuitionalColor:String = "";
      
      private var _skin:String;
      
      private var _paopaoType:int = 0;
      
      public var SuperAttack:int;
      
      public var Delay:int;
      
      private var _attack:int;
      
      private var _answerSite:int;
      
      private var _defence:int;
      
      private var _luck:int;
      
      private var _hp:int;
      
      public var increaHP:int;
      
      private var _agility:int;
      
      private var _magicAttack:int;
      
      private var _magicDefence:int;
      
      private var _dungeonFlag:Object;
      
      private var _propertyAddition:DictionaryData;
      
      private var _bag:BagInfo;
      
      public var _beadBag:BagInfo;
      
      private var _deputyWeaponID:int = 0;
      
      private var _webSpeed:int;
      
      private var _weaponID:int;
      
      protected var _buffInfo:DictionaryData = new DictionaryData();
      
      private var _pveEpicPermission:String;
      
      private var _pvePermission:String;
      
      public var _isDupSimpleTip:Boolean = false;
      
      private var _fightLibMission:String;
      
      private var _lastSpaDate:Object;
      
      private var _masterOrApprentices:DictionaryData;
      
      private var _masterID:int;
      
      private var _graduatesCount:int;
      
      private var _honourOfMaster:String = "";
      
      public var _freezesDate:Date;
      
      private var _myGiftData:Vector.<MyGiftCellInfo>;
      
      private var _charmLevel:int;
      
      private var _charmGP:int;
      
      private var _cardEquipDic:DictionaryData;
      
      private var _cardBagDic:DictionaryData;
      
      public var OptionOnOff:int;
      
      private var _shopFinallyGottenTime:Date;
      
      private var _lastDate:Date;
      
      private var _isSameCity:Boolean;
      
      public var _IsShowConsortia:Boolean;
      
      private var _badLuckNumber:int;
      
      protected var _isSelf:Boolean = false;
      
      protected var _pets:DictionaryData;
      
      protected var _snapPet:PetInfo;
      
      protected var _snapDeputyWeaponID:int;
      
      public var flagID:int;
      
      private var _damageScores:int = 0;
      
      private var _embedUpLevelCell:EmbedUpLevelCell;
      
      private var _totemId:int;
      
      private var _gemstoneList:Vector.<GemstonInitInfo>;
      
      private var _hardCurrency:int;
      
      private var _leagueMoney:int;
      
      private var _necklaceExp:int;
      
      private var _necklaceLevel:int;
      
      private var _necklaceExpAdd:int;
      
      private var _pvpBadgeId:int;
      
      public var Damage:int;
      
      public var Blood:int;
      
      public var Energy:int;
      
      public var Guard:int;
      
      private var _isTrusteeship:Boolean;
      
      private var _fightStatus:int;
      
      private var _accumulativeLoginDays:int;
      
      private var _accumulativeAwardDays:int;
      
      private var _evolutionGrade:int;
      
      public var DungeonExpTotalNum:int;
      
      public var DungeonExpReceiveNum:int;
      
      private var _evolutionExp:int;
      
      private var _horseInBookRidingID:int = 0;
      
      private var _horsePicCherishBlood:int;
      
      private var _horsePicCherishGuard:int;
      
      private var _horsePicCherishHurt:int;
      
      private var _horsePicCherishMagicAttack:int;
      
      private var _horsePicCherishMagicDefence:int;
      
      private var _horsePicCherishDic:DictionaryData;
      
      private var _peerID:String;
      
      public var curHorseLevel:int;
      
      public function PlayerInfo()
      {
         super();
      }
      
      override public function updateProperties() : void
      {
         if(Boolean(_changedPropeties[ARM]) || Boolean(_changedPropeties[SEX]) || Boolean(_changedPropeties[STYLE]) || Boolean(_changedPropeties[HIDE]) || Boolean(_changedPropeties[SKIN]) || Boolean(_changedPropeties[COLORS]) || Boolean(_changedPropeties[NIMBUS]))
         {
            this.parseHide();
            this.parseStyle();
            this.parseColos();
            this._showSuits = this._modifyStyle.split(",")[7].split("|")[0] != "13101" && this._modifyStyle.split(",")[7].split("|")[0] != "13201";
            _changedPropeties[PlayerInfo.STYLE] = true;
         }
         super.updateProperties();
      }
      
      override public function set Sex(value:Boolean) : void
      {
         _Sex = value;
         super.onPropertiesChanged("Sex");
      }
      
      private function parseHide() : void
      {
         this._hidehat = String(this._hide).charAt(8) == "2";
         this._hideGlass = String(this._hide).charAt(7) == "2";
         this._suitesHide = String(this._hide).charAt(6) == "2";
         this._wingHide = String(this._hide).charAt(5) == "2";
      }
      
      private function parseStyle() : void
      {
         var tid:String = null;
         if(this._style == null || this._style == "")
         {
            this._style = ",,,,,,,,,";
         }
         var s:Array = this._style.split(",");
         for(var i:int = 0; i < s.length; i++)
         {
            tid = this.getTID(s[i]);
            if((tid == "" || tid == "0" || tid == "-1") && i + 1 != EquipType.ARM && i < 7)
            {
               s[i] = this.replaceTID(s[i],String(i + 1) + (Sex ? "1" : "2") + "01");
            }
            else if((tid == "" || tid == "0" || tid == "-1") && i + 1 == EquipType.ARM)
            {
               s[i] = this.replaceTID(s[i],"700" + (Sex ? "1" : "2"),false);
            }
            if((tid == "" || tid == "0" || tid == "-1") && i == 7)
            {
               s[i] = this.replaceTID(s[i],"13" + (Sex ? "1" : "2") + "01");
            }
            if((tid == "" || tid == "0" || tid == "-1") && i == 8)
            {
               s[i] = this.replaceTID(s[i],"15001");
            }
            if((tid == "" || tid == "0" || tid == "-1") && i == 9)
            {
               s[i] = this.replaceTID(s[i],"16000");
            }
         }
         if(this._hidehat || this._hideGlass || this._suitesHide)
         {
            if(this._hidehat)
            {
               s[0] = this.replaceTID(s[0],"1" + (Sex ? "1" : "2") + "01");
            }
            if(this._hideGlass)
            {
               s[1] = this.replaceTID(s[1],"2" + (Sex ? "1" : "2") + "01");
            }
            if(this._suitesHide)
            {
               if(!(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.FIGHTFOOTBALLTIME_ROOM))
               {
                  s[7] = this.replaceTID(s[7],"13" + (Sex ? "1" : "2") + "01");
               }
            }
         }
         this._modifyStyle = s.join(",");
      }
      
      public function get lastLuckNum() : int
      {
         return this._lastLuckNum;
      }
      
      public function set lastLuckNum(value:int) : void
      {
         if(this._lastLuckNum == value)
         {
            return;
         }
         this._lastLuckNum = value;
         onPropertiesChanged(PlayerPropertyType.LastLuckyNum);
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      public function set luckyNum(value:int) : void
      {
         if(this._luckyNum == value)
         {
            return;
         }
         this._luckyNum = value;
      }
      
      public function get lastLuckyNumDate() : Date
      {
         return this._lastLuckyNumDate;
      }
      
      public function set lastLuckyNumDate(value:Date) : void
      {
         if(this._lastLuckyNumDate == value)
         {
            return;
         }
         this._lastLuckyNumDate = value;
      }
      
      public function get attachtype() : int
      {
         return this._attachtype;
      }
      
      public function get attachvalue() : int
      {
         return this._attachvalue;
      }
      
      private function parseColos() : void
      {
         var arr:Array = this._colors.split(",");
         var t:Array = arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]].split("|");
         arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]] = t[0] + "|" + this._skin + "|" + (t[2] == undefined ? "" : t[2]);
         t = arr[EquipType.CategeryIdToPlace(EquipType.CLOTH)[0]].split("|");
         arr[EquipType.CategeryIdToPlace(EquipType.CLOTH)[0]] = t[0] + "|" + this._skin + "|" + (t[2] == undefined ? "" : t[2]);
         this._colors = arr.join(",");
      }
      
      public function get Hide() : int
      {
         return this._hide;
      }
      
      public function set Hide(value:int) : void
      {
         if(this._hide == value)
         {
            return;
         }
         this._hide = value;
         onPropertiesChanged("Hide");
      }
      
      public function getHatHide() : Boolean
      {
         return this._hidehat;
      }
      
      public function setHatHide(value:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,8) + (value ? "2" : "1") + String(this._hide).slice(9));
      }
      
      public function getGlassHide() : Boolean
      {
         return this._hideGlass;
      }
      
      public function setGlassHide(value:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,7) + (value ? "2" : "1") + String(this._hide).slice(8,9));
      }
      
      public function getSuitesHide() : Boolean
      {
         return this._suitesHide;
      }
      
      public function setSuiteHide(value:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,6) + (value ? "2" : "1") + String(this._hide).slice(7,9));
      }
      
      public function getShowSuits() : Boolean
      {
         return this._showSuits;
      }
      
      public function get wingHide() : Boolean
      {
         return this._wingHide;
      }
      
      public function set wingHide(value:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,5) + (value ? "2" : "1") + String(this._hide).slice(6,9));
      }
      
      public function set Nimbus(nim:int) : void
      {
         if(this._nimbus == nim)
         {
            return;
         }
         this._nimbus = nim;
         onPropertiesChanged("Nimbus");
      }
      
      public function get Nimbus() : int
      {
         return this._nimbus;
      }
      
      public function getHaveLight() : Boolean
      {
         if(this.Nimbus < 100)
         {
            return false;
         }
         if(this.Nimbus > 999)
         {
            return String(this.Nimbus).charAt(0) != "0" || String(this.Nimbus).charAt(1) != "0";
         }
         return String(this.Nimbus).charAt(0) != "0";
      }
      
      public function getHaveCircle() : Boolean
      {
         if(this.Nimbus == 0)
         {
            return false;
         }
         if(this.Nimbus > 999)
         {
            return String(this.Nimbus).charAt(2) != "0" || String(this.Nimbus).charAt(3) != "0";
         }
         if(this.Nimbus > 99)
         {
            return String(this.Nimbus).charAt(1) != "0" || String(this.Nimbus).charAt(2) != "0";
         }
         return String(this.Nimbus).charAt(0) != "0";
      }
      
      public function get Style() : String
      {
         if(this._style == null)
         {
            return null;
         }
         return this._modifyStyle;
      }
      
      public function set Style(value:String) : void
      {
         var addFixStyleCount:int = 0;
         var i:int = 0;
         if(this._style == value)
         {
            return;
         }
         if(value == null)
         {
            return;
         }
         var styleValues:Array = value.split(",");
         if(styleValues.length < 10)
         {
            addFixStyleCount = 10 - styleValues.length;
            for(i = 0; i < addFixStyleCount; i++)
            {
               styleValues.push("|");
            }
            value = styleValues.join(",");
         }
         for(var j:int = 0; j < 10; j++)
         {
         }
         this._style = value;
         onPropertiesChanged("Style");
      }
      
	  public function getHairType() : int
	  {
		  if (!this._modifyStyle || this._modifyStyle == "")
		  {
			  //trace("[getHairType] _modifyStyle is null or empty");
			  return 0;
		  }
		  
		  var places:Array = EquipType.CategeryIdToPlace(EquipType.HEAD);
		  if (!places || places.length == 0)
		  {
			  //trace("[getHairType] EquipType.CategeryIdToPlace returned null or empty");
			  return 0;
		  }
		  
		  var index:int = places[0];
		  var parts:Array = this._modifyStyle.split(",");
		  if (index >= parts.length)
		  {
			  //trace("[getHairType] Index out of range:", index, "in", parts);
			  return 0;
		  }
		  
		  var itemStr:String = parts[index];
		  if (!itemStr || itemStr.indexOf("|") == -1)
		  {
			  //trace("[getHairType] Invalid item string:", itemStr);
			  return 0;
		  }
		  
		  var templateId:int = int(itemStr.split("|")[0]);
		  var template:Object = ItemManager.Instance.getTemplateById(templateId);
		  if (!template)
		  {
			  //trace("[getHairType] Template not found for ID:", templateId);
			  return 0;
		  }
		  
		  return int(template.Property1);
	  }
      
      public function getSuitsType() : int
      {
         var rInt:int = int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[7].split("|")[0]).Property1);
         if(Boolean(rInt))
         {
            return rInt;
         }
         return 2;
      }
      
      public function getPrivateStyle() : String
      {
         return this._style;
      }
      
      public function get TutorialProgress() : int
      {
         return this._tutorialProgress;
      }
      
      public function set TutorialProgress(value:int) : void
      {
         if(this._tutorialProgress == value)
         {
            return;
         }
         this._tutorialProgress = value;
         onPropertiesChanged("TutorialProgress");
      }
      
      public function setPartStyle(categoryId:int, needsex:int, templateId:int = -1, color:String = "", dispatch:Boolean = true) : void
      {
         if(this.Style == null)
         {
            return;
         }
         var arr:Array = this._style.split(",");
         if(categoryId == EquipType.ARM)
         {
            arr[EquipType.CategeryIdToPlace(categoryId)[0]] = this.replaceTID(arr[EquipType.CategeryIdToPlace(categoryId)[0]],templateId == -1 || templateId == 0 ? "700" + String(PlayerManager.Instance.Self.Sex ? "1" : "2") : String(templateId),false);
         }
         else if(categoryId == EquipType.SUITS)
         {
            arr[7] = this.replaceTID(arr[7],templateId == -1 || templateId == 0 ? String(categoryId) + "101" : String(templateId));
         }
         else if(categoryId == EquipType.WING)
         {
            arr[8] = this.replaceTID(arr[8],templateId == -1 || templateId == 0 ? "15001" : String(templateId));
         }
         else
         {
            arr[
				EquipType.CategeryIdToPlace(categoryId)[0]] = 
					this.replaceTID(arr[EquipType.CategeryIdToPlace(categoryId)[0]],templateId == -1 || 
						
						templateId == 0 ? String(categoryId) + String(needsex) + "01" : String(templateId)
					);
         }
         this._style = arr.join(",");
         onPropertiesChanged("Style");
         this.setPartColor(categoryId,color);
      }
      
      private function jionPic(tid:String, pic:String) : String
      {
         return tid + "|" + pic;
      }
      
      private function getTID(s:String) : String
      {
         return s.split("|")[0];
      }
      
	  private function replaceTID(original:String, tid:String, useTemplatePic:Boolean = true) : String
	  {
		  var template:Object = null;
		  if (!original || original.indexOf("|") == -1)
		  {
			  // Eğer original null veya format hatalıysa
			  //trace("[replaceTID] original null veya hatalı:", original);
			  original = tid + "|defaultPic";
		  }
		  
		  if (useTemplatePic)
		  {
			  template = ItemManager.Instance.getTemplateById(int(tid));
			  if (template == null)
			  {
				  //trace("[replaceTID] Template bulunamadı, tid:", tid);
				  return tid + "|" + original.split("|")[1]; // fallback
			  }
			  return tid + "|" + template.Pic;
		  }
		  
		  return tid + "|" + original.split("|")[1];
	  }
      
      public function getPartStyle(categoryId:int) : int
      {
         return int(this.Style.split(",")[categoryId - 1].split("|")[0]);
      }
      
      public function get Colors() : String
      {
         return this._colors;
      }
      
      public function set Colors(value:String) : void
      {
         if(this._intuitionalColor == value)
         {
            return;
         }
         this._intuitionalColor = value;
         if(this.colorEqual(this._colors,value))
         {
            return;
         }
         this._colors = value;
         onPropertiesChanged("Colors");
      }
      
      private function colorEqual(color_1:String, color_2:String) : Boolean
      {
         if(color_1 == color_2)
         {
            return true;
         }
         var colors1:Array = color_1.split(",");
         var colors2:Array = color_2.split(",");
         for(var i:int = 0; i < colors2.length; i++)
         {
            if(i == 4)
            {
               if(colors1[i].split("|").length > 2)
               {
                  colors1[i] = colors1[i].split("|")[0] + "||" + colors1[i].split("|")[2];
               }
            }
            if(colors1[i] != colors2[i])
            {
               if(!((colors1[i] == "|" || colors1[i] == "||" || colors1[i] == "") && (colors2[i] == "|" || colors2[i] == "||" || colors2[i] == "")))
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function setPartColor(id:int, color:String) : void
      {
         var arr:Array = this._colors.split(",");
         if(id != EquipType.SUITS)
         {
            arr[EquipType.CategeryIdToPlace(id)[0]] = color;
         }
         this.Colors = arr.join(",");
         onPropertiesChanged(PlayerInfo.COLORS);
      }
      
      public function getPartColor(id:int) : String
      {
         var arr:Array = this.Colors.split(",");
         return arr[id - 1];
      }
      
      public function setSkinColor(color:String) : void
      {
         this.Skin = color;
      }
      
      public function set Skin(color:String) : void
      {
         if(this._skin == color)
         {
            return;
         }
         this._skin = color;
         onPropertiesChanged("Colors");
      }
      
      public function get Skin() : String
      {
         return this.getSkinColor();
      }
      
      public function getSkinColor() : String
      {
         var arr:Array = this.Colors.split(",");
         if(arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]] == undefined)
         {
            return "";
         }
         var t:String = arr[EquipType.CategeryIdToPlace(EquipType.FACE)[0]].split("|")[1];
         return t == null ? "" : t;
      }
      
      public function clearColors() : void
      {
         this.Colors = ",,,,,,,,";
      }
      
      public function updateStyle(sex:Boolean, hide:int, style:String, colors:String, skin:String) : void
      {
         beginChanges();
         this.Sex = sex;
         this.Hide = hide;
         this.Style = style;
         this.Colors = colors;
         this.Skin = skin;
         commitChanges();
      }
      
      public function get paopaoType() : int
      {
         var st:String = this._style.split(",")[9].split("|")[0];
         st.slice(4);
         if(st == null || st == "" || st == "0" || st == "-1")
         {
            return 0;
         }
         return int(st.slice(3));
      }
      
      public function get Attack() : int
      {
         return this._attack;
      }
      
      public function set Attack(value:int) : void
      {
         if(this._attack == value)
         {
            return;
         }
         this._attack = value;
         onPropertiesChanged("Attack");
      }
      
      public function set userGuildProgress(p:int) : void
      {
         this._answerSite = p;
         this.TutorialProgress = p;
         NewHandGuideManager.Instance.progress = p;
      }
      
      public function get userGuildProgress() : int
      {
         return this._answerSite;
      }
      
      public function get Defence() : int
      {
         return this._defence;
      }
      
      public function set Defence(value:int) : void
      {
         if(this._defence == value)
         {
            return;
         }
         this._defence = value;
         onPropertiesChanged("Defence");
      }
      
      public function get Luck() : int
      {
         return this._luck;
      }
      
      public function set Luck(value:int) : void
      {
         if(this._luck == value)
         {
            return;
         }
         this._luck = value;
         onPropertiesChanged("Luck");
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(value:int) : void
      {
         if(this._hp != value)
         {
            this.increaHP = value - this._hp;
         }
         this._hp = value;
      }
      
      public function get Agility() : int
      {
         return this._agility;
      }
      
      public function set Agility(value:int) : void
      {
         if(this._agility == value)
         {
            return;
         }
         this._agility = value;
         onPropertiesChanged("Agility");
      }
      
      public function get MagicAttack() : int
      {
         return this._magicAttack;
      }
      
      public function set MagicAttack(value:int) : void
      {
         if(this._magicAttack == value)
         {
            return;
         }
         this._magicAttack = value;
         onPropertiesChanged("MagicAttack");
      }
      
      public function get MagicDefence() : int
      {
         return this._magicDefence;
      }
      
      public function set MagicDefence(value:int) : void
      {
         if(this._magicDefence == value)
         {
            return;
         }
         this._magicDefence = value;
         onPropertiesChanged("MagicDefence");
      }
      
      public function setAttackDefenseValues(attack:int, defense:int, agility:int, luck:int, magicAttack:int, magicDefence:int) : void
      {
         this.Attack = attack;
         this.Defence = defense;
         this.Agility = agility;
         this.Luck = luck;
         this.MagicAttack = magicAttack;
         this.MagicDefence = magicDefence;
         onPropertiesChanged("setAttackDefenseValues");
      }
      
      public function get dungeonFlag() : Object
      {
         if(this._dungeonFlag == null)
         {
            this._dungeonFlag = new Object();
         }
         return this._dungeonFlag;
      }
      
      public function set dungeonFlag(value:Object) : void
      {
         if(this._dungeonFlag == value)
         {
            return;
         }
         this._dungeonFlag = value;
      }
      
      public function get propertyAddition() : DictionaryData
      {
         if(!this._propertyAddition)
         {
            this._propertyAddition = new DictionaryData();
         }
         return this._propertyAddition;
      }
      
      public function set propertyAddition(val:DictionaryData) : void
      {
         this._propertyAddition = val;
      }
      
      public function getPropertyAdditionByType(type:String) : DictionaryData
      {
         return this._propertyAddition[type];
      }
      
      public function get Bag() : BagInfo
      {
         if(this._bag == null)
         {
            this._bag = new BagInfo(BagInfo.EQUIPBAG,46);
         }
         return this._bag;
      }
      
      public function get BeadBag() : BagInfo
      {
         if(this._beadBag == null)
         {
            this._beadBag = new BagInfo(BagInfo.BEADBAG,178);
         }
         return this._beadBag;
      }
      
      public function get DeputyWeapon() : InventoryItemInfo
      {
         var arr:Array = this.Bag.findBodyThingByCategory(EquipType.OFFHAND).concat(this.Bag.findBodyThingByCategory(EquipType.TEMP_OFFHAND));
         if(arr.length > 0)
         {
            return arr[0] as InventoryItemInfo;
         }
         return null;
      }
      
      public function set DeputyWeaponID(value:int) : void
      {
         if(this._deputyWeaponID == value)
         {
            return;
         }
         this._deputyWeaponID = value;
         onPropertiesChanged("DeputyWeaponID");
      }
      
      public function get DeputyWeaponID() : int
      {
         return this._deputyWeaponID;
      }
      
      public function get SnapDeputyWeapon() : InventoryItemInfo
      {
         var iteminfo:InventoryItemInfo = new InventoryItemInfo();
         iteminfo.TemplateID = this.snapDeputyWeaponID;
         ItemManager.fill(iteminfo);
         return iteminfo;
      }
      
      public function get webSpeed() : int
      {
         return this._webSpeed;
      }
      
      public function set webSpeed(value:int) : void
      {
         this._webSpeed = value;
         dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
      }
      
      public function get WeaponID() : int
      {
         return this._weaponID;
      }
      
      public function set WeaponID(value:int) : void
      {
         if(this._weaponID == value)
         {
            return;
         }
         this._weaponID = value;
         onPropertiesChanged("WeaponID");
      }
      
      public function set paopaoType(type:int) : void
      {
         this._paopaoType = type;
         onPropertiesChanged("paopaoType");
      }
      
      public function get buffInfo() : DictionaryData
      {
         return this._buffInfo;
      }
      
      protected function set buffInfo(buffs:DictionaryData) : void
      {
         this._buffInfo = buffs;
         onPropertiesChanged("buffInfo");
      }
      
      public function addBuff(buff:BuffInfo) : void
      {
         this._buffInfo.add(buff.Type,buff);
      }
      
      public function clearBuff() : void
      {
         this._buffInfo.clear();
      }
      
      public function hasBuff(buffType:int) : Boolean
      {
         if(buffType == BuffInfo.FREE)
         {
            return true;
         }
         var buff:BuffInfo = this.getBuff(buffType);
         return buff != null && buff.IsExist;
      }
      
      public function getBuff(buffType:int) : BuffInfo
      {
         return this._buffInfo[buffType];
      }
      
      public function set PveEpicPermission(value:String) : void
      {
         if(this._pveEpicPermission == value)
         {
            return;
         }
         this._pveEpicPermission = value;
         onPropertiesChanged("PveEpicPermission");
      }
      
      public function get PveEpicPermission() : String
      {
         return this._pveEpicPermission;
      }
      
      public function get PvePermission() : String
      {
         return this._pvePermission;
      }
      
      public function set PvePermission(permission:String) : void
      {
         if(this._pvePermission == permission)
         {
            return;
         }
         if(permission == "")
         {
            this._pvePermission = "11111111111111111111111111111111111111111111111111";
         }
         else
         {
            if(this._pvePermission != null)
            {
               if(this._pvePermission.substr(0,1) == "1" && permission.substr(0,1) == "3")
               {
                  this._isDupSimpleTip = true;
               }
            }
            this._pvePermission = permission;
         }
         onPropertiesChanged("PvePermission");
      }
      
      public function get fightLibMission() : String
      {
         return this._fightLibMission == null || this._fightLibMission == "" ? "0000000000" : this._fightLibMission;
      }
      
      public function set fightLibMission(value:String) : void
      {
         this._fightLibMission = value;
         onPropertiesChanged("fightLibMission");
      }
      
      public function get LastSpaDate() : Object
      {
         return this._lastSpaDate;
      }
      
      public function set LastSpaDate(value:Object) : void
      {
         this._lastSpaDate = value;
      }
      
      public function setMasterOrApprentices(value:String) : void
      {
         var nickNames:Array = null;
         var i:int = 0;
         var idOrNickName:Array = null;
         if(!this._masterOrApprentices)
         {
            this._masterOrApprentices = new DictionaryData();
         }
         this._masterOrApprentices.clear();
         if(value != "")
         {
            nickNames = value.split(",");
            for(i = 0; i < nickNames.length; i++)
            {
               idOrNickName = nickNames[i].split("|");
               this._masterOrApprentices.add(int(idOrNickName[0]),idOrNickName[1]);
            }
         }
         onPropertiesChanged("masterOrApprentices");
      }
      
      public function getMasterOrApprentices() : DictionaryData
      {
         if(!this._masterOrApprentices)
         {
            this._masterOrApprentices = new DictionaryData();
         }
         return this._masterOrApprentices;
      }
      
      public function set masterID(value:int) : void
      {
         this._masterID = value;
      }
      
      public function get masterID() : int
      {
         return this._masterID;
      }
      
      public function isMyMaster(id:int) : Boolean
      {
         return id == this._masterID;
      }
      
      public function isMyApprent(id:int) : Boolean
      {
         return this._masterOrApprentices[id];
      }
      
      public function set graduatesCount(value:int) : void
      {
         this._graduatesCount = value;
      }
      
      public function get graduatesCount() : int
      {
         return this._graduatesCount;
      }
      
      public function set honourOfMaster(value:String) : void
      {
         this._honourOfMaster = value;
      }
      
      public function get honourOfMaster() : String
      {
         return this._honourOfMaster;
      }
      
      public function set freezesDate(value:Date) : void
      {
         this._freezesDate = value;
      }
      
      public function get freezesDate() : Date
      {
         return this._freezesDate;
      }
      
      public function set myGiftData(list:Vector.<MyGiftCellInfo>) : void
      {
         this._myGiftData = list;
         onPropertiesChanged("myGiftData");
      }
      
      public function get myGiftData() : Vector.<MyGiftCellInfo>
      {
         if(this._myGiftData == null)
         {
            this._myGiftData = new Vector.<MyGiftCellInfo>();
         }
         return this._myGiftData;
      }
      
      public function get giftSum() : int
      {
         var info:MyGiftCellInfo = null;
         var sum:int = 0;
         for each(info in this.myGiftData)
         {
            sum += info.amount;
         }
         return sum;
      }
      
      public function set charmLevel(value:int) : void
      {
         this._charmLevel = value;
         onPropertiesChanged("GiftLevel");
      }
      
      public function get charmLevel() : int
      {
         if(this.charmGP <= 0)
         {
            return 1;
         }
         return this._charmLevel;
      }
      
      public function set charmGP(value:int) : void
      {
         this._charmGP = value;
         this.charmLevel = this.getCharLevel(value);
         onPropertiesChanged("GiftGp");
      }
      
      private function getCharLevel(value:int) : int
      {
         var level:int = 0;
         for(var i:int = 0; i < CHARM_LEVEL_ALL_EXP.length; i++)
         {
            if(value >= CHARM_LEVEL_ALL_EXP[MAX_CHARM_LEVEL - 1])
            {
               level = MAX_CHARM_LEVEL;
               break;
            }
            if(value < CHARM_LEVEL_ALL_EXP[i])
            {
               level = i;
               break;
            }
            if(value <= 0)
            {
               level = 1;
               break;
            }
         }
         return level;
      }
      
      public function get charmGP() : int
      {
         return this._charmGP;
      }
      
      public function get cardEquipDic() : DictionaryData
      {
         if(this._cardEquipDic == null)
         {
            this._cardEquipDic = new DictionaryData();
         }
         return this._cardEquipDic;
      }
      
      public function set cardEquipDic(value:DictionaryData) : void
      {
         if(this._cardEquipDic == value)
         {
            return;
         }
         this._cardEquipDic = value;
         onPropertiesChanged("cardEquipDic");
      }
      
      public function get cardBagDic() : DictionaryData
      {
         if(this._cardBagDic == null)
         {
            this._cardBagDic = new DictionaryData();
         }
         return this._cardBagDic;
      }
      
      public function set cardBagDic(value:DictionaryData) : void
      {
         if(this._cardBagDic == value)
         {
            return;
         }
         this._cardBagDic = value;
         onPropertiesChanged("cardBagDic");
      }
      
      public function getOptionState(OptionType:int) : Boolean
      {
         return (this.OptionOnOff & OptionType) == OptionType;
      }
      
      public function get shopFinallyGottenTime() : Date
      {
         return this._shopFinallyGottenTime;
      }
      
      public function set shopFinallyGottenTime(value:Date) : void
      {
         if(this._shopFinallyGottenTime == value)
         {
            return;
         }
         this._shopFinallyGottenTime = value;
         dispatchEvent(new Event(UPDATE_SHOP_FINALLY_TIME));
      }
      
      public function getLastDate() : int
      {
         var totalHours:int = 0;
         var now:Date = TimeManager.Instance.Now();
         var hours:int = (now.valueOf() - this._lastDate.valueOf()) / 3600000;
         return hours < 1 ? 1 : hours;
      }
      
      public function set lastDate(value:Date) : void
      {
         this._lastDate = value;
      }
      
      public function get lastDate() : Date
      {
         return this._lastDate;
      }
      
      public function get isSameCity() : Boolean
      {
         return this._isSameCity;
      }
      
      public function set isSameCity(value:Boolean) : void
      {
         this._isSameCity = value;
      }
      
      public function set IsShowConsortia(boo:Boolean) : void
      {
         this._IsShowConsortia = boo;
      }
      
      public function get IsShowConsortia() : Boolean
      {
         return this._IsShowConsortia;
      }
      
      public function get showDesignation() : String
      {
         var str:String = this.IsShowConsortia ? ConsortiaName : honor;
         if(!str)
         {
            str = ConsortiaName;
         }
         if(!str)
         {
            str = honor;
         }
         return str;
      }
      
      public function get badLuckNumber() : int
      {
         return this._badLuckNumber;
      }
      
      public function set badLuckNumber(value:int) : void
      {
         if(this._badLuckNumber != value)
         {
            this._badLuckNumber = value;
            onPropertiesChanged("BadLuckNumber");
         }
      }
      
      public function shouldShowAcademyIcon() : Boolean
      {
         if(apprenticeshipState == AcademyManager.NONE_STATE && (Grade < AcademyManager.TARGET_PLAYER_MIN_LEVEL || AcademyManager.Instance.isOpenSpace(this)))
         {
            return false;
         }
         return true;
      }
      
      public function get isSelf() : Boolean
      {
         return this._isSelf;
      }
      
      public function set isSelf(value:Boolean) : void
      {
         this._isSelf = value;
      }
      
      public function get pets() : DictionaryData
      {
         if(this._pets == null)
         {
            this._pets = new DictionaryData();
         }
         return this._pets;
      }
      
      public function get currentPet() : PetInfo
      {
         var petInfo:PetInfo = null;
         var resultPetInfo:PetInfo = null;
         for each(petInfo in this._pets)
         {
            if(petInfo.IsEquip)
            {
               resultPetInfo = petInfo;
            }
         }
         return resultPetInfo;
      }
      
      public function get snapPet() : PetInfo
      {
         return this._snapPet;
      }
      
      public function set snapPet(value:PetInfo) : void
      {
         if(Boolean(value))
         {
            this._snapPet = value;
         }
      }
      
      public function get snapDeputyWeaponID() : int
      {
         return this._snapDeputyWeaponID;
      }
      
      public function set snapDeputyWeaponID(value:int) : void
      {
         if(Boolean(value))
         {
            this._snapDeputyWeaponID = value;
            onPropertiesChanged("snapDeputyWeaponID");
         }
      }
      
      public function set damageScores(value:int) : void
      {
         if(this._damageScores == value)
         {
            return;
         }
         this._damageScores = value;
         onPropertiesChanged("damageScores");
      }
      
      public function get damageScores() : int
      {
         return this._damageScores;
      }
      
      public function get embedUpLevelCell() : EmbedUpLevelCell
      {
         return this._embedUpLevelCell;
      }
      
      public function set embedUpLevelCell(value:EmbedUpLevelCell) : void
      {
         this._embedUpLevelCell = value;
      }
      
      public function get totemId() : int
      {
         return this._totemId;
      }
      
      public function set totemId(value:int) : void
      {
         this._totemId = value;
         TotemManager.instance.updatePropertyAddtion(this._totemId,this.propertyAddition);
      }
      
      public function set gemstoneList(list:Vector.<GemstonInitInfo>) : void
      {
         this._gemstoneList = list;
      }
      
      public function get gemstoneList() : Vector.<GemstonInitInfo>
      {
         return this._gemstoneList;
      }
      
      public function get hardCurrency() : int
      {
         return this._hardCurrency;
      }
      
      public function set hardCurrency(value:int) : void
      {
         if(this._hardCurrency == value)
         {
            return;
         }
         this._hardCurrency = value;
         onPropertiesChanged("hardCurrency");
      }
      
      public function get leagueMoney() : int
      {
         return this._leagueMoney;
      }
      
      public function set leagueMoney(value:int) : void
      {
         this._leagueMoney = value;
         onPropertiesChanged("leagueMoney");
      }
      
      public function get necklaceExp() : int
      {
         return this._necklaceExp;
      }
      
      public function set necklaceExp(value:int) : void
      {
         this._necklaceExp = value;
         this.necklaceLevel = StoreEquipExperience.getNecklaceLevelByGP(this._necklaceExp);
         onPropertiesChanged("necklaceExp");
      }
      
      public function get necklaceLevel() : int
      {
         return this._necklaceLevel;
      }
      
      public function set necklaceLevel(value:int) : void
      {
         this._necklaceLevel = value;
         onPropertiesChanged("necklaceLevel");
      }
      
      public function get necklaceExpAdd() : int
      {
         return this._necklaceExpAdd;
      }
      
      public function set necklaceExpAdd(value:int) : void
      {
         this._necklaceExpAdd = value;
         onPropertiesChanged("necklaceExpAdd");
      }
      
      public function get pvpBadgeId() : int
      {
         return this._pvpBadgeId;
      }
      
      public function set pvpBadgeId(value:int) : void
      {
         this._pvpBadgeId = value;
      }
      
      public function get isTrusteeship() : Boolean
      {
         return this._isTrusteeship;
      }
      
      public function set isTrusteeship(value:Boolean) : void
      {
         this._isTrusteeship = value;
         dispatchEvent(new GameEvent(GameEvent.TRUSTEESHIP_CHANGE,value));
      }
      
      public function get fightStatus() : int
      {
         return this._fightStatus;
      }
      
      public function set fightStatus(value:int) : void
      {
         this._fightStatus = value;
         dispatchEvent(new GameEvent(GameEvent.FIGHT_STATUS_CHANGE,value));
      }
      
      public function get accumulativeLoginDays() : int
      {
         return this._accumulativeLoginDays;
      }
      
      public function set accumulativeLoginDays(value:int) : void
      {
         this._accumulativeLoginDays = value;
      }
      
      public function get accumulativeAwardDays() : int
      {
         return this._accumulativeAwardDays;
      }
      
      public function set accumulativeAwardDays(value:int) : void
      {
         this._accumulativeAwardDays = value;
      }
      
      public function get evolutionGrade() : int
      {
         return this._evolutionGrade;
      }
      
      public function set evolutionGrade(value:int) : void
      {
         this._evolutionGrade = value;
      }
      
      public function get evolutionExp() : int
      {
         return this._evolutionExp;
      }
      
      public function set evolutionExp(value:int) : void
      {
         this._evolutionExp = value;
      }
      
      public function get horsePicCherishBlood() : int
      {
         return this._horsePicCherishBlood;
      }
      
      public function set horsePicCherishBlood(value:int) : void
      {
         this._horsePicCherishBlood = value;
      }
      
      public function get horsePicCherishGuard() : int
      {
         return this._horsePicCherishGuard;
      }
      
      public function set horsePicCherishGuard(value:int) : void
      {
         this._horsePicCherishGuard = value;
      }
      
      public function get horsePicCherishHurt() : int
      {
         return this._horsePicCherishHurt;
      }
      
      public function set horsePicCherishHurt(value:int) : void
      {
         this._horsePicCherishHurt = value;
      }
      
      public function get horsePicCherishMagicAttack() : int
      {
         return this._horsePicCherishMagicAttack;
      }
      
      public function set horsePicCherishMagicAttack(value:int) : void
      {
         this._horsePicCherishMagicAttack = value;
      }
      
      public function get horsePicCherishMagicDefence() : int
      {
         return this._horsePicCherishMagicDefence;
      }
      
      public function set horsePicCherishMagicDefence(value:int) : void
      {
         this._horsePicCherishMagicDefence = value;
      }
      
      public function get horsePicCherishDic() : DictionaryData
      {
         if(this._horsePicCherishDic == null)
         {
            this._horsePicCherishDic = new DictionaryData();
         }
         return this._horsePicCherishDic;
      }
      
      public function set peerID(id:String) : void
      {
         this._peerID = id;
      }
      
      public function get peerID() : String
      {
         return this._peerID;
      }
      
      public function get horseInBookRidingID() : int
      {
         return this._horseInBookRidingID;
      }
      
      public function set horseInBookRidingID(value:int) : void
      {
         this._horseInBookRidingID = value;
      }
	  
	  private var _guardCoreID:int;
	  private var _guardCoreGrade:int;
	  
	  public function get guardCoreID() : int
	  {
		  return this._guardCoreID;
	  }
	  
	  public function set guardCoreID(param1:int) : void
	  {
		  if(this._guardCoreID == param1)
		  {
			  return;
		  }
		  this._guardCoreID = param1;
		  onPropertiesChanged("GuardCoreID");
	  }
	  
	  public function get guardCoreGrade() : int
	  {
		  return this._guardCoreGrade;
	  }
	  
	  public function set guardCoreGrade(param1:int) : void
	  {
		  if(this._guardCoreGrade == param1)
		  {
			  return;
		  }
		  this._guardCoreGrade = param1;
		  onPropertiesChanged("GuardCoreGrade");
	  }
   }
}

