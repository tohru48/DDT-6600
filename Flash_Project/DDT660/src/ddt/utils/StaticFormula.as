package ddt.utils
{
   import GodSyah.SyahManager;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import game.model.Living;
   import road7th.data.DictionaryData;
   import totem.TotemManager;
   
   public class StaticFormula
   {
      
      public function StaticFormula()
      {
         super();
      }
      
      public static function getHertAddition(baseHert:int, strengthenLevel:int) : Number
      {
         var val:Number = baseHert * Math.pow(1.1,strengthenLevel) - baseHert;
         return Math.round(val);
      }
      
      public static function getDefenseAddition(baseDefense:int, strengthenLevel:int) : Number
      {
         var val:Number = baseDefense * Math.pow(1.1,strengthenLevel) - baseDefense;
         return Math.round(val);
      }
      
      public static function getRecoverHPAddition(baseRecover:int, strengthenLevel:int) : Number
      {
         var val:Number = baseRecover * Math.pow(1.1,strengthenLevel) - baseRecover;
         return Math.floor(val);
      }
      
      public static function getImmuneHertAddition(allDefense:int) : Number
      {
         var val:Number = 0.95 * allDefense / (allDefense + 500);
         val *= 100;
         return Number(val.toFixed(1));
      }
      
      public static function isDeputyWeapon($info:ItemTemplateInfo) : Boolean
      {
         if($info.TemplateID >= 17000 && $info.TemplateID <= 17020)
         {
            return true;
         }
         return false;
      }
      
      public static function getActionValue(info:PlayerInfo) : int
      {
         var ActionValue:int = 0;
         return int((info.Attack + info.Agility + info.Luck + info.Defence + 1000) * (Math.pow(getDamage(info),3) + Math.pow(getRecovery(info),3) * 3.5) / 100000000 + getMaxHp(info) * 0.95 - 950);
      }
      
      public static function isShield(info:PlayerInfo) : Boolean
      {
         return false;
      }
      
      public static function getDamage(info:PlayerInfo) : int
      {
         var damage:int = 0;
         if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var tmpInfo:InventoryItemInfo = info.Bag.items[6] as InventoryItemInfo;
         if(Boolean(tmpInfo))
         {
            damage = getHertAddition(int(tmpInfo.Property7),tmpInfo.StrengthenLevel + (tmpInfo.isGold ? 1 : 0)) + int(tmpInfo.Property7);
         }
         if(Boolean(info.propertyAddition) && Boolean(info.propertyAddition["Damage"]))
         {
            damage += Boolean(info.propertyAddition["Damage"]["Bead"]) ? info.propertyAddition["Damage"]["Bead"] : 0;
            damage += Boolean(info.propertyAddition["Damage"]["Avatar"]) ? info.propertyAddition["Damage"]["Avatar"] : 0;
            damage += Boolean(info.propertyAddition["Damage"]["Horse"]) ? info.propertyAddition["Damage"]["Horse"] : 0;
            damage += Boolean(info.propertyAddition["Damage"]["HorsePicCherish"]) ? info.propertyAddition["Damage"]["HorsePicCherish"] : 0;
         }
         damage += getCardDamageAddition(info);
         if(PathManager.suitEnable)
         {
            damage += getSuitAddition(info,"Damage");
         }
         damage += TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(info.totemId)).Damage;
         return damage + SyahManager.Instance.totalDamage;
      }
      
      public static function getCardDamageAddition(info:PlayerInfo) : int
      {
         var card:CardInfo = null;
         var cardTempleteInfo:CardTemplateInfo = null;
         var damage:int = 0;
         for each(card in info.cardEquipDic.list)
         {
            cardTempleteInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(card.TemplateID),String(card.CardType));
            damage += int(cardTempleteInfo.AddDamage) + card.Damage;
         }
         return damage;
      }
      
      public static function getRecovery(info:PlayerInfo) : int
      {
         var recovery:int = 0;
         if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var tmpInfo:InventoryItemInfo = info.Bag.items[0] as InventoryItemInfo;
         if(Boolean(tmpInfo))
         {
            recovery = getDefenseAddition(int(tmpInfo.Property7),tmpInfo.StrengthenLevel + (tmpInfo.isGold ? 1 : 0)) + int(tmpInfo.Property7);
         }
         tmpInfo = info.Bag.items[4] as InventoryItemInfo;
         if(Boolean(tmpInfo))
         {
            recovery += getDefenseAddition(int(tmpInfo.Property7),tmpInfo.StrengthenLevel + (tmpInfo.isGold ? 1 : 0)) + int(tmpInfo.Property7);
         }
         if(Boolean(info.propertyAddition) && Boolean(info.propertyAddition["Armor"]))
         {
            recovery += Boolean(info.propertyAddition["Armor"]["Bead"]) ? info.propertyAddition["Armor"]["Bead"] : 0;
            recovery += Boolean(info.propertyAddition["Armor"]["Avatar"]) ? info.propertyAddition["Armor"]["Avatar"] : 0;
            recovery += Boolean(info.propertyAddition["Armor"]["Horse"]) ? info.propertyAddition["Armor"]["Horse"] : 0;
            recovery += Boolean(info.propertyAddition["Armor"]["HorsePicCherish"]) ? info.propertyAddition["Armor"]["HorsePicCherish"] : 0;
            recovery += Boolean(info.propertyAddition["Armor"]["Pet"]) ? info.propertyAddition["Armor"]["Pet"] : 0;
         }
         recovery += getCardRecoveryAddition(info);
         if(PathManager.suitEnable)
         {
            recovery += getSuitAddition(info,"Guard");
         }
         recovery += TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(info.totemId)).Guard;
         return recovery + SyahManager.Instance.totalArmor;
      }
      
      public static function getCardRecoveryAddition(info:PlayerInfo) : int
      {
         var card:CardInfo = null;
         var cardTempleteInfo:CardTemplateInfo = null;
         var recovery:int = 0;
         for each(card in info.cardEquipDic.list)
         {
            cardTempleteInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(card.TemplateID),String(card.CardType));
            recovery += int(cardTempleteInfo.AddGuard) + card.Guard;
         }
         return recovery;
      }
      
      public static function getMaxHp(info:PlayerInfo) : int
      {
         return info.hp;
      }
      
      public static function getSuitAddition(info:PlayerInfo, key:String) : int
      {
         if(info.propertyAddition == null)
         {
            return 0;
         }
         var val:int = 0;
         var valDic:DictionaryData = info.getPropertyAdditionByType(key);
         if(Boolean(valDic) && Boolean(valDic["Suit"]))
         {
            val = int(valDic["Suit"]);
         }
         return val;
      }
      
      public static function getEnergy(info:PlayerInfo) : int
      {
         if(info.ZoneID != 0 && StateManager.currentStateType == StateType.FIGHTING && info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var value:int = 0;
         return int(240 + info.Agility / 30);
      }
      
      private static function isDamageJewel(item:ItemTemplateInfo) : Boolean
      {
         if(item.CategoryID == 11 && item.Property1 == "31" && item.Property2 == "3")
         {
            return true;
         }
         return false;
      }
      
      public static function getBeadDamage(info:PlayerInfo) : int
      {
         var bead:InventoryItemInfo = null;
         var value:int = 0;
         var beadBag:BagInfo = info.BeadBag;
         for(var i:int = 3; i < 12; i++)
         {
            bead = beadBag.items[i];
            if(Boolean(bead) && isDamageJewel(bead))
            {
               value += int(bead.Property7);
            }
         }
         return value;
      }
      
      public static function getBeadRecovery(info:PlayerInfo) : int
      {
         var bead:InventoryItemInfo = null;
         var value:int = 0;
         var beadBag:BagInfo = info.BeadBag;
         for(var i:int = 3; i < 12; i++)
         {
            bead = beadBag.items[i];
            if(Boolean(bead))
            {
               value += int(bead.Property8);
            }
         }
         return value;
      }
      
      public static function getJewelDamage(itemInfo:InventoryItemInfo) : int
      {
         var value:int = 0;
         if(!itemInfo)
         {
            return 0;
         }
         if(itemInfo.Hole1 != -1 && itemInfo.Hole1 != 0 && int(itemInfo.StrengthenLevel / 3) >= 1)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(itemInfo.Hole1)))
            {
               value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole1).Property7);
            }
         }
         if(itemInfo.Hole2 != -1 && itemInfo.Hole2 != 0 && int(itemInfo.StrengthenLevel / 3) >= 2)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(itemInfo.Hole2)))
            {
               value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole2).Property7);
            }
         }
         if(itemInfo.Hole3 != -1 && itemInfo.Hole3 != 0 && int(itemInfo.StrengthenLevel / 3) >= 3)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(itemInfo.Hole3)))
            {
               value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole3).Property7);
            }
         }
         if(itemInfo.Hole4 != -1 && itemInfo.Hole4 != 0 && int(itemInfo.StrengthenLevel / 3) >= 4)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(itemInfo.Hole4)))
            {
               value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole4).Property7);
            }
         }
         if(itemInfo.Hole5 != -1 && itemInfo.Hole5 != 0 && itemInfo.Hole5Level > 0)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(itemInfo.Hole5)))
            {
               value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole5).Property7);
            }
         }
         if(itemInfo.Hole6 != -1 && itemInfo.Hole6 != 0 && itemInfo.Hole6Level > 0)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(itemInfo.Hole6)))
            {
               value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole6).Property7);
            }
         }
         return value;
      }
      
      public static function getJewelRecovery(itemInfo:InventoryItemInfo) : int
      {
         var value:int = 0;
         if(!itemInfo)
         {
            return 0;
         }
         if(itemInfo.Hole1 != -1 && itemInfo.Hole1 != 0 && int(itemInfo.StrengthenLevel / 3) >= 1)
         {
            value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole1).Property8);
         }
         if(itemInfo.Hole2 != -1 && itemInfo.Hole2 != 0 && int(itemInfo.StrengthenLevel / 3) >= 2)
         {
            value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole2).Property8);
         }
         if(itemInfo.Hole3 != -1 && itemInfo.Hole3 != 0 && int(itemInfo.StrengthenLevel / 3) >= 3)
         {
            value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole3).Property8);
         }
         if(itemInfo.Hole4 != -1 && itemInfo.Hole4 != 0 && int(itemInfo.StrengthenLevel / 3) >= 4)
         {
            value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole4).Property8);
         }
         if(itemInfo.Hole5 != -1 && itemInfo.Hole5 != 0 && itemInfo.Hole5Level > 0)
         {
            value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole5).Property8);
         }
         if(itemInfo.Hole6 != -1 && itemInfo.Hole6 != 0 && itemInfo.Hole6Level > 0)
         {
            value += int(ItemManager.Instance.getTemplateById(itemInfo.Hole6).Property8);
         }
         return value;
      }
   }
}

