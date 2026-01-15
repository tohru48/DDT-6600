package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class LevelPrivilegeView extends Sprite implements Disposeable
   {
      
      private static const MAX_LEVEL:int = 12;
      
      private static const VIP_SETTINGS_FIELD:Array = ["VIPRwardInfo","VIPRateForGP","VIPStrengthenEx","VIPQuestStar","VIPBruiedStar","VIPLotteryCountMaxPerDay","VIPExtraBindMoneyUpper","VIPTakeCardDisCount","VIPLotteryNoTime","VIPBossBattle","CanBuyFert","FarmAssistant","PetFifthSkill","LoginSysNotice","VIPMetalRelieve","VIPWeekly","VIPBenediction","VIPCrytBoss"];
      
      private var _bg:Image;
      
      private var _titleBg:Image;
      
      private var _titleSeperators:Image;
      
      private var _titleTxt:FilterFrameText;
      
      private var _titleIcons:Vector.<Image>;
      
      private var _itemScrollPanel:ScrollPanel;
      
      private var _itemContainer:VBox;
      
      private var _seperator:Image;
      
      private var _currentVip:Image;
      
      private var _units:Dictionary;
      
      private var _minPrivilegeLevel:Dictionary = new Dictionary();
      
      public function LevelPrivilegeView()
      {
         super();
         this._units = new Dictionary();
         this._units[2] = "%";
         this._units[5] = this._units[6] = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.TimesUnit");
         this._units[7] = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.DiscountUnit");
         this.initView();
         this.initItem();
      }
      
      private function initItem() : void
      {
         var j:int;
         var data:Vector.<String>;
         var item:PrivilegeViewItem = null;
         var item2:PrivilegeViewItem = null;
         for(j = 0; j <= 7; j++)
         {
            item = null;
            if(j == 0)
            {
               this.parseVipIconItem();
            }
            else
            {
               if(j == 3 || j == 4)
               {
                  item = new PrivilegeViewItem(PrivilegeViewItem.GRAPHICS_TYPE,"asset.vip.star");
               }
               else
               {
                  if(j == 4)
                  {
                     continue;
                  }
                  if(this._units[j] != null)
                  {
                     item = new PrivilegeViewItem(PrivilegeViewItem.UNIT_TYPE,this._units[j]);
                  }
                  else
                  {
                     item = new PrivilegeViewItem();
                  }
               }
               item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[j]);
               if(j == 1)
               {
                  item.contentInterceptor = function(val:String):String
                  {
                     return Number(val).toFixed(1);
                  };
               }
               else if(j == 7)
               {
                  item.crossFilter = "100";
                  item.contentInterceptor = function(val:String):String
                  {
                     return (Number(val) / 10).toString();
                  };
               }
               if(j == 4)
               {
                  item.itemContent = Vector.<String>(ServerConfigManager.instance.analyzeData("VIPQuestStar"));
               }
               else if(j != 0)
               {
                  item.itemContent = Vector.<String>(ServerConfigManager.instance.analyzeData(VIP_SETTINGS_FIELD[j]));
               }
               if(j != 5)
               {
                  this._itemContainer.addChild(item);
               }
            }
         }
         this.parsePrivilegeItem(11,9);
         this.parsePrivilegeItem(8,10);
         this.parsePrivilegeItem(10,11);
         this.parsePrivilegeItem(9,12);
         this.parsePrivilegeItem(12,13);
         data = Vector.<String>(["1","1","1","1","1","1","1","1","1","1","1","1"]);
         for(j = 14; j <= 15; j++)
         {
            item2 = new PrivilegeViewItem(PrivilegeViewItem.TRUE_FLASE_TYPE);
            item2.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[j]);
            item2.itemContent = data;
            this._itemContainer.addChild(item2);
         }
         this.parseBenediction();
         this.parseRingStation(20);
         this.famCleanOutHalf();
         this._itemScrollPanel.invalidateViewport();
      }
      
      private function famCleanOutHalf() : void
      {
         var data:Array = new Array();
         for(var i:int = 1; i <= MAX_LEVEL; i++)
         {
            if(i >= 6 && i <= 8)
            {
               data.push("Half");
            }
            else if(i > 8)
            {
               data.push("ücretsiz");
            }
            else
            {
               data.push("0");
            }
         }
         var item:PrivilegeViewItem = new PrivilegeViewItem();
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPFamCleanOut");
         item.itemContent = Vector.<String>(data);
         this._itemContainer.addChild(item);
      }
      
      private function parseVIPCryptBoss() : void
      {
         var data:Vector.<String> = Vector.<String>(["0","0","0","1","1","1","1","1","2","2","2","2"]);
         var item:PrivilegeViewItem = new PrivilegeViewItem(PrivilegeViewItem.NORMAL_TYPE);
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[17]);
         item.itemContent = data;
         this._itemContainer.addChild(item);
      }
      
      private function parseVipIconItem() : void
      {
         var infoArr:Array = GiveYourselfOpenView.getVipinfo();
         var item:PrivilegeViewItem = new PrivilegeViewItem(PrivilegeViewItem.ICON_TYPE);
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPRwardInfo");
         item.itemContentForIcontype = infoArr;
         this._itemContainer.addChild(item);
      }
      
      private function parsePrivilegeItem(privilegeNo:int, itemIndex:int) : void
      {
         var data:Array = new Array();
         var minLevel:int = ServerConfigManager.instance.getPrivilegeMinLevel(privilegeNo.toString());
         for(var i:int = 1; i <= MAX_LEVEL; i++)
         {
            data.push(i >= minLevel ? "1" : "0");
         }
         var item:PrivilegeViewItem = new PrivilegeViewItem(PrivilegeViewItem.TRUE_FLASE_TYPE);
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[itemIndex]);
         item.itemContent = Vector.<String>(data);
         this._itemContainer.addChild(item);
      }
      
      private function parseBenediction() : void
      {
         var maxLevel:int = 0;
         var data:Vector.<String> = Vector.<String>(["0","0","0","0","0","0","0","0","0","0","0","0"]);
         for(var i:int = 1; i <= 7; i++)
         {
            data[ServerConfigManager.instance.getPrivilegeMinLevel(i.toString()) - 1] = i.toString();
         }
         maxLevel = ServerConfigManager.instance.getPrivilegeMinLevel("7");
         for(var j:int = maxLevel; j < MAX_LEVEL; j++)
         {
            data[j] = "All";
         }
         var item:PrivilegeViewItem = new PrivilegeViewItem();
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[16]);
         item.analyzeFunction = this.benedictionAnalyzer;
         item.itemContent = data;
         this._itemContainer.addChild(item);
      }
      
      private function benedictionAnalyzer(content:Vector.<String>) : Vector.<DisplayObject>
      {
         var con:String = null;
         var txt:FilterFrameText = null;
         var cross:DisplayObject = null;
         var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var startPos:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeBenedctionItemTxtStartPos");
         for each(con in content)
         {
            if(con != "0")
            {
               txt = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewBenedctionItemTxt");
               txt.text = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.MayneRand" + con);
               PositionUtils.setPos(txt,startPos);
               txt.x += 6;
               txt.y -= 5;
               startPos.x += 40 + 5;
               result.push(txt);
               this.autoText(txt);
            }
            else
            {
               cross = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
               PositionUtils.setPos(cross,startPos);
               cross.x = startPos.x + (40 - cross.width);
               startPos.x += 40 + 5;
               result.push(cross);
            }
         }
         return result;
      }
      
      private function autoText(_txt:FilterFrameText) : void
      {
      }
      
      private function parseRingStation(privilegeNo:int) : void
      {
         var data:Array = new Array();
         var minLevel:int = ServerConfigManager.instance.getPrivilegeMinLevel(privilegeNo.toString());
         for(var i:int = 1; i <= MAX_LEVEL; i++)
         {
            data.push(i >= minLevel ? "1" : "0");
         }
         var item:PrivilegeViewItem = new PrivilegeViewItem(PrivilegeViewItem.TRUE_FLASE_TYPE);
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPRingStation");
         item.itemContent = Vector.<String>(data);
         this._itemContainer.addChild(item);
      }
      
      private function parseMissionFast(privilegeNo:int) : void
      {
         var data:Array = new Array();
         for(var i:int = 1; i <= MAX_LEVEL; i++)
         {
            data.push(i >= 9 ? "1" : "0");
         }
         var item:PrivilegeViewItem = new PrivilegeViewItem(PrivilegeViewItem.TRUE_FLASE_TYPE);
         item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPMissionFast");
         item.itemContent = Vector.<String>(data);
         this._itemContainer.addChild(item);
      }
      
      private function initView() : void
      {
         var icon:Image = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeViewBg");
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeTitleBg");
         this._titleSeperators = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewTitleItemSeperators");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.TitleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.vip.LevelPrivilegeView.TitleTxt");
         this._seperator = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeSeperator");
         this._currentVip = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.currentVip");
         this._currentVip.x += (PlayerManager.Instance.Self.VIPLevel - 1) * 45;
         this._currentVip.visible = PlayerManager.Instance.Self.IsVIP;
         addChild(this._bg);
         addChild(this._titleBg);
         addChild(this._titleSeperators);
         addChild(this._titleTxt);
         addChild(this._seperator);
         this._titleIcons = new Vector.<Image>();
         var xPos:int = 0;
         var yPos:int = 0;
         for(var i:int = 1; i <= MAX_LEVEL; i++)
         {
            icon = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.VipIcon" + i);
            this._titleIcons.push(icon);
            addChild(icon);
            if(i == 1)
            {
               xPos = icon.x;
               yPos = icon.y;
            }
            else
            {
               xPos += 45;
               icon.x = xPos;
               icon.y = yPos;
            }
         }
         addChild(this._currentVip);
         this._itemScrollPanel = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.ItemScrollPanel");
         addChild(this._itemScrollPanel);
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemContainer");
         this._itemScrollPanel.setView(this._itemContainer);
      }
      
      public function dispose() : void
      {
         var img:Image = null;
         for each(img in this._titleIcons)
         {
            ObjectUtils.disposeObject(img);
         }
         this._titleIcons = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._titleBg);
         ObjectUtils.disposeObject(this._titleSeperators);
         ObjectUtils.disposeObject(this._titleTxt);
         ObjectUtils.disposeObject(this._itemContainer);
         ObjectUtils.disposeObject(this._itemScrollPanel);
         ObjectUtils.disposeObject(this._seperator);
         ObjectUtils.disposeObject(this._currentVip);
         this._bg = null;
         this._titleBg = null;
         this._titleSeperators = null;
         this._titleTxt = null;
         this._itemScrollPanel = null;
         this._itemContainer = null;
         this._seperator = null;
         this._currentVip = null;
      }
   }
}

