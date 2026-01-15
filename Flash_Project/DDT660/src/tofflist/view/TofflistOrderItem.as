package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import tofflist.data.TofflistConsortiaData;
   import tofflist.data.TofflistConsortiaInfo;
   import tofflist.data.TofflistPlayerInfo;
   import vip.VipController;
   
   public class TofflistOrderItem extends Sprite implements Disposeable
   {
      
      private var _consortiaInfo:TofflistConsortiaInfo;
      
      private var _badge:Badge;
      
      private var _index:int;
      
      private var _info:TofflistPlayerInfo;
      
      private var _isSelect:Boolean;
      
      private var _bg:Image;
      
      private var _shine:Scale9CornerImage;
      
      private var _level:LevelIcon;
      
      private var _vipName:GradientText;
      
      private var _topThreeRink:ScaleFrameImage;
      
      private var _horseNameStrList:Array;
      
      private var _levelStar:Bitmap;
      
      private var _resourceArr:Array;
      
      private var _styleLinkArr:Array;
      
      private var hLines:Array;
      
      public function TofflistOrderItem()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function get currentText() : String
      {
         return this._resourceArr[2].dis["text"];
      }
      
      public function dispose() : void
      {
         var bm:Bitmap = null;
         var dis:DisplayObject = null;
         var i:uint = 0;
         var total:uint = 0;
         this.removeEvent();
         if(Boolean(this.hLines))
         {
            for each(bm in this.hLines)
            {
               ObjectUtils.disposeObject(bm);
            }
         }
         if(Boolean(this._resourceArr))
         {
            i = 0;
            for(total = this._resourceArr.length; i < total; )
            {
               dis = this._resourceArr[i].dis;
               ObjectUtils.disposeObject(dis);
               dis = null;
               this._resourceArr[i] = null;
               i++;
            }
            this._resourceArr = null;
         }
         this._styleLinkArr = null;
         this._badge.dispose();
         this._badge = null;
         this._bg.dispose();
         this._bg = null;
         ObjectUtils.disposeAllChildren(this);
         this._shine = null;
         if(Boolean(this._topThreeRink))
         {
            this._topThreeRink.dispose();
         }
         this._topThreeRink = null;
         if(Boolean(this._levelStar))
         {
            this._levelStar.bitmapData.dispose();
         }
         this._levelStar = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(i:int) : void
      {
         this._index = i;
         this._bg.setFrame(this._index % 2 + 1);
      }
      
      public function get MountsLevel() : String
      {
         return this._info.MountsLevelInfo;
      }
      
      public function showHLine(points:Vector.<Point>) : void
      {
         var p:Point = null;
         var bm:Bitmap = null;
         if(Boolean(this.hLines))
         {
            for each(bm in this.hLines)
            {
               ObjectUtils.disposeObject(bm);
            }
         }
         this.hLines = [];
         for each(p in points)
         {
            bm = ComponentFactory.Instance.creatBitmap("asset.corel.formLine");
            addChild(bm);
            this.hLines.push(bm);
            PositionUtils.setPos(bm,new Point(p.x - parent.parent.x,p.y));
         }
      }
      
      public function get info() : Object
      {
         return this._info;
      }
      
      public function set info($info:Object) : void
      {
         var $consortiaInfo:TofflistConsortiaData = null;
         if($info is PlayerInfo)
         {
            this._info = $info as TofflistPlayerInfo;
         }
         else if($info is TofflistConsortiaData)
         {
            $consortiaInfo = $info as TofflistConsortiaData;
            if(Boolean($consortiaInfo))
            {
               this._info = $consortiaInfo.playerInfo;
               this._consortiaInfo = $consortiaInfo.consortiaInfo;
            }
         }
         if(Boolean(this._info))
         {
            this.upView();
         }
      }
      
      public function set isSelect(b:Boolean) : void
      {
         this._shine.visible = this._isSelect = b;
         if(b)
         {
            this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_ITEM_SELECT,this));
         }
      }
      
      public function set resourceLink(value:String) : void
      {
         var dis:DisplayObject = null;
         var obj:Object = null;
         this._resourceArr = [];
         var tempArr:Array = value.replace(/(\s*)|(\s*$)/g,"").split("|");
         var i:uint = 0;
         for(var total:uint = tempArr.length; i < total; )
         {
            obj = {};
            obj.id = tempArr[i].split("#")[0];
            obj.className = tempArr[i].split("#")[1];
            dis = ComponentFactory.Instance.creat(obj.className);
            addChild(dis);
            obj.dis = dis;
            this._resourceArr.push(obj);
            i++;
         }
      }
      
      public function set setAllStyleXY(value:String) : void
      {
         this._styleLinkArr = value.replace(/(\s*)|(\s*$)/g,"").split("~");
         this.updateStyleXY();
      }
      
      public function updateStyleXY($id:int = 0) : void
      {
         var dis:DisplayObject = null;
         var i:uint = 0;
         var j:uint = 0;
         var tempArr:Array = null;
         var id:int = 0;
         var pot:Point = null;
         var total:uint = this._resourceArr.length;
         tempArr = this._styleLinkArr[$id].split("|");
         total = tempArr.length;
         for(i = 0; i < total; i++)
         {
            dis = null;
            id = int(tempArr[i].split("#")[0]);
            for(j = 0; j < this._resourceArr.length; j++)
            {
               if(id == this._resourceArr[j].id)
               {
                  dis = this._resourceArr[j].dis;
                  break;
               }
            }
            if(Boolean(dis))
            {
               pot = new Point();
               pot.x = tempArr[i].split("#")[1].split(",")[0];
               pot.y = tempArr[i].split("#")[1].split(",")[1];
               dis.x = pot.x;
               dis.y = pot.y;
               if(Boolean(tempArr[i].split("#")[1].split(",")[2]))
               {
                  dis.width = tempArr[i].split("#")[1].split(",")[2];
               }
               if(Boolean(tempArr[i].split("#")[1].split(",")[3]))
               {
                  dis.height = tempArr[i].split("#")[1].split(",")[3];
               }
               dis["text"] = dis["text"];
               dis.visible = true;
            }
         }
         if(this._index < 4)
         {
            this._topThreeRink.x = this._resourceArr[0].dis.x - 9;
            this._topThreeRink.y = this._resourceArr[0].dis.y - 2;
            this._topThreeRink.visible = true;
            this._topThreeRink.setFrame(this._index);
            this._resourceArr[0].dis.visible = false;
         }
      }
      
      private function get NO_ID() : String
      {
         var str:String = "";
         switch(this._index)
         {
            case 1:
               str = 1 + "st";
               break;
            case 2:
               str = 2 + "nd";
               break;
            case 3:
               str = 3 + "rd";
               break;
            default:
               str = this._index + "th";
         }
         return str;
      }
      
      private function __itemClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isSelect)
         {
            this.isSelect = true;
         }
      }
      
      private function __itemMouseOutHandler(evt:MouseEvent) : void
      {
         if(this._isSelect)
         {
            return;
         }
         this._shine.visible = false;
      }
      
      private function __itemMouseOverHandler(evt:MouseEvent) : void
      {
         this._shine.visible = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOutHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function __offerChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["isVip"]))
         {
            this.upView();
         }
      }
      
      private function init() : void
      {
         this._horseNameStrList = LanguageMgr.GetTranslation("horse.horseNameStr").split(",");
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,495,30);
         this.graphics.endFill();
         this.buttonMode = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("tofflist.gridItemBg");
         this._bg.setFrame(this._index % 2 + 1);
         addChild(this._bg);
         this._shine = ComponentFactory.Instance.creat("tofflist.orderlistitem.shine");
         this._shine.visible = false;
         addChild(this._shine);
         this._badge = new Badge();
         this._badge.visible = false;
         addChild(this._badge);
         PositionUtils.setPos(this._badge,"tofflist.item.badgePos");
         this._level = new LevelIcon();
         this._level.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._level);
         this._level.visible = false;
         this._topThreeRink = ComponentFactory.Instance.creat("toffilist.topThreeRink");
         addChild(this._topThreeRink);
         this._topThreeRink.visible = false;
         this._levelStar = ComponentFactory.Instance.creat("asset.Toffilist.levelStarTxtImage");
         addChild(this._levelStar);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOutHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__offerChange);
      }
      
      private function upView() : void
      {
         var dis:DisplayObject = null;
         var i:uint = 0;
         var textFormat:TextFormat = null;
         var textFormat1:TextFormat = null;
         var total:uint = this._resourceArr.length;
         for(i = 0; i < total; i++)
         {
            dis = this._resourceArr[i].dis;
            dis["text"] = "";
            dis.visible = false;
         }
         this._resourceArr[0].dis["text"] = this.NO_ID;
         this._levelStar.visible = false;
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               this._resourceArr[1].dis["text"] = this._info.NickName;
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(0);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(1);
                     if(Boolean(this._vipName))
                     {
                        this._vipName.x = this._resourceArr[1].dis.x - this._vipName.width / 2;
                     }
                     this._level.x = 227;
                     this._level.y = 3;
                     this._level.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
                     this._level.visible = true;
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GP;
                     }
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(2);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(3);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGiftGp;
                           this._resourceArr[3].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGiftGp;
                           this._resourceArr[3].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GiftGp;
                           this._resourceArr[3].dis["text"] = this._info.GiftLevel;
                     }
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this.updateStyleXY(4);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = String(this._info.TotalPrestige);
                     }
                     break;
                  case TofflistTwoGradeMenu.MOUNTS:
                     this.updateStyleXY(17);
                     this._levelStar.visible = true;
                     PositionUtils.setPos(this._levelStar,"tofflist.person.levelStarPos");
                     this._resourceArr[3].dis["text"] = this._horseNameStrList[this._info.MountsLevel];
                     this._resourceArr[5].dis["text"] = String(this._info.MountsLevelInfo);
               }
               if(this._info.IsVIP)
               {
                  if(Boolean(this._vipName))
                  {
                     ObjectUtils.disposeObject(this._vipName);
                  }
                  this._vipName = VipController.instance.getVipNameTxt(1,this._info.typeVIP);
                  textFormat = new TextFormat();
                  textFormat.align = "center";
                  textFormat.bold = true;
                  this._vipName.textField.defaultTextFormat = textFormat;
                  this._vipName.textSize = 16;
                  this._vipName.textField.width = this._resourceArr[1].dis.width;
                  this._vipName.x = this._resourceArr[1].dis.x;
                  this._vipName.y = this._resourceArr[1].dis.y;
                  this._vipName.text = this._info.NickName;
               }
               PositionUtils.adaptNameStyle(this._info,this._resourceArr[1].dis,this._vipName);
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               this._resourceArr[1].dis["text"] = this._info.NickName;
               this._resourceArr[3].dis["text"] = Boolean(this._info.AreaName) ? this._info.AreaName : "";
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(9);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(10);
                     if(Boolean(this._vipName))
                     {
                        this._vipName.x = this._resourceArr[1].dis.x - this._vipName.width / 2;
                     }
                     this._level.x = 208;
                     this._level.y = 3;
                     this._level.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
                     this._level.visible = true;
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GP;
                     }
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(11);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(12);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._info.AddDayGiftGp;
                           this._resourceArr[4].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._info.AddWeekGiftGp;
                           this._resourceArr[4].dis["text"] = this._info.GiftLevel;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._info.GiftGp;
                           this._resourceArr[4].dis["text"] = this._info.GiftLevel;
                     }
                     break;
                  case TofflistTwoGradeMenu.MOUNTS:
                     this.updateStyleXY(18);
                     this._levelStar.visible = true;
                     PositionUtils.setPos(this._levelStar,"tofflist.cross.levelStarPos");
                     this._resourceArr[2].dis["text"] = this._horseNameStrList[this._info.MountsLevel];
                     this._resourceArr[5].dis["text"] = this._info.MountsLevelInfo;
               }
               if(this._info.IsVIP)
               {
                  if(Boolean(this._vipName))
                  {
                     ObjectUtils.disposeObject(this._vipName);
                  }
                  this._vipName = VipController.instance.getVipNameTxt(1,this._info.typeVIP);
                  textFormat1 = new TextFormat();
                  textFormat1.align = "center";
                  textFormat1.bold = true;
                  this._vipName.textField.defaultTextFormat = textFormat1;
                  this._vipName.textSize = 16;
                  this._vipName.textField.width = this._resourceArr[1].dis.width;
                  this._vipName.x = this._resourceArr[1].dis.x;
                  this._vipName.y = this._resourceArr[1].dis.y;
                  this._vipName.text = this._info.NickName;
                  addChild(this._vipName);
               }
               PositionUtils.adaptNameStyle(this._info,this._resourceArr[1].dis,this._vipName);
               break;
            case TofflistStairMenu.CONSORTIA:
               if(!this._consortiaInfo)
               {
                  break;
               }
               this._badge.visible = this._consortiaInfo.BadgeID > 0;
               this._badge.badgeID = this._consortiaInfo.BadgeID;
               this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(5);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(6);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                           this._resourceArr[3].dis["text"] = this._consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(7);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(8);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddDayGiftGp;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddWeekGiftGp;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaGiftGp;
                     }
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               if(!this._consortiaInfo)
               {
                  break;
               }
               this._badge.visible = this._consortiaInfo.BadgeID > 0;
               this._badge.badgeID = this._consortiaInfo.BadgeID;
               this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
               if(Boolean(this._consortiaInfo.AreaName))
               {
                  this._resourceArr[3].dis["text"] = this._consortiaInfo.AreaName;
               }
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(13);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                     }
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(14);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                           this._resourceArr[4].dis["text"] = this._consortiaInfo.Level;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(15);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(16);
                     switch(TofflistModel.thirdMenuType)
                     {
                        case TofflistThirdClassMenu.DAY:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddDayGiftGp;
                           break;
                        case TofflistThirdClassMenu.WEEK:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaAddWeekGiftGp;
                           break;
                        case TofflistThirdClassMenu.TOTAL:
                           this._resourceArr[2].dis["text"] = this._consortiaInfo.ConsortiaGiftGp;
                     }
               }
               break;
         }
         if(Boolean(this._vipName))
         {
            addChild(this._vipName);
         }
      }
      
      public function get consortiaInfo() : ConsortiaInfo
      {
         return this._consortiaInfo;
      }
   }
}

