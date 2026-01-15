package totem.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftWindowView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _bgList:Vector.<Bitmap>;
      
      private var _totemPointBgList:Vector.<BitmapData>;
      
      private var _totemPointIconList:Vector.<BitmapData>;
      
      private var _totemPointSprite:Sprite;
      
      private var _totemPointList:Vector.<TotemLeftWindowTotemCell>;
      
      private var _curCanClickPointLocation:int;
      
      private var _totemPointLocationList:Array = [[{
         "x":300,
         "y":300
      },{
         "x":100,
         "y":300
      },{
         "x":100,
         "y":100
      },{
         "x":200,
         "y":200
      },{
         "x":300,
         "y":100
      },{
         "x":450,
         "y":150
      },{
         "x":450,
         "y":300
      }],[{
         "x":100,
         "y":100
      },{
         "x":100,
         "y":300
      },{
         "x":200,
         "y":200
      },{
         "x":300,
         "y":300
      },{
         "x":450,
         "y":300
      },{
         "x":450,
         "y":150
      },{
         "x":300,
         "y":100
      }],[{
         "x":100,
         "y":200
      },{
         "x":150,
         "y":100
      },{
         "x":250,
         "y":200
      },{
         "x":150,
         "y":300
      },{
         "x":350,
         "y":300
      },{
         "x":450,
         "y":200
      },{
         "x":350,
         "y":100
      }],[{
         "x":100,
         "y":300
      },{
         "x":100,
         "y":100
      },{
         "x":250,
         "y":150
      },{
         "x":250,
         "y":300
      },{
         "x":400,
         "y":300
      },{
         "x":450,
         "y":200
      },{
         "x":350,
         "y":100
      }],[{
         "x":300,
         "y":300
      },{
         "x":200,
         "y":200
      },{
         "x":100,
         "y":300
      },{
         "x":100,
         "y":100
      },{
         "x":300,
         "y":100
      },{
         "x":450,
         "y":300
      },{
         "x":450,
         "y":150
      }]];
      
      private var _windowBorder:Bitmap;
      
      private var _lineShape:Shape;
      
      private var _lightGlowFilter:GlowFilter;
      
      private var _grayGlowFilter:ColorMatrixFilter;
      
      private var _openCartoonSprite:TotemLeftWindowOpenCartoonView;
      
      private var _propertyTxtSprite:TotemLeftWindowPropertyTxtView;
      
      private var _tipView:TotemPointTipView;
      
      private var _chapterIcon:TotemLeftWindowChapterIcon;
      
      public function TotemLeftWindowView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var i:int = 0;
         this._windowBorder = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.windowBorder");
         this._windowBorder.smoothing = true;
         addChild(this._windowBorder);
         this._bgList = new Vector.<Bitmap>();
         for(i = 1; i <= 5; i++)
         {
            this._bgList.push(ComponentFactory.Instance.creatBitmap("asset.totem.leftView.windowBg" + i));
         }
         this._totemPointBgList = new Vector.<BitmapData>();
         for(i = 1; i <= 5; i++)
         {
            this._totemPointBgList.push(ComponentFactory.Instance.creatBitmapData("asset.totem.totemPointBg" + i));
         }
         this._totemPointIconList = new Vector.<BitmapData>();
         for(i = 1; i <= 7; i++)
         {
            this._totemPointIconList.push(ComponentFactory.Instance.creatBitmapData("asset.totem.totemPointIcon" + i));
         }
         this._openCartoonSprite = new TotemLeftWindowOpenCartoonView(this._totemPointLocationList,this.refreshGlowFilter,this.refreshTotemPoint);
         this._propertyTxtSprite = new TotemLeftWindowPropertyTxtView();
         this._lineShape = new Shape();
         addChild(this._lineShape);
         this._lightGlowFilter = new GlowFilter(52479,1,20,20,2,BitmapFilterQuality.MEDIUM);
         this._grayGlowFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
         this._tipView = new TotemPointTipView();
         this._tipView.visible = false;
         LayerManager.Instance.addToLayer(this._tipView,LayerManager.GAME_TOP_LAYER);
         this._chapterIcon = ComponentFactory.Instance.creatCustomObject("totem.totemChapterIcon");
      }
      
      public function refreshView(nextPointInfo:TotemDataVo, callback:Function = null) : void
      {
         this._openCartoonSprite.refreshView(nextPointInfo,callback);
      }
      
      public function openFailHandler(nextPointInfo:TotemDataVo) : void
      {
         this._openCartoonSprite.failRefreshView(nextPointInfo,this.enableCurCanClickBtn);
      }
      
      private function enableCurCanClickBtn() : void
      {
         if(this._curCanClickPointLocation != 0 && Boolean(this._totemPointList))
         {
            this._totemPointList[this._curCanClickPointLocation - 1].mouseChildren = true;
            this._totemPointList[this._curCanClickPointLocation - 1].mouseEnabled = true;
         }
      }
      
      private function disenableCurCanClickBtn() : void
      {
         if(this._curCanClickPointLocation != 0 && Boolean(this._totemPointList))
         {
            this._totemPointList[this._curCanClickPointLocation - 1].mouseChildren = false;
            this._totemPointList[this._curCanClickPointLocation - 1].mouseEnabled = false;
         }
      }
      
      public function show(page:int, nextPointInfo:TotemDataVo, isSelf:Boolean) : void
      {
         if(page == 0)
         {
            page = 1;
         }
         if(Boolean(this._bg))
         {
            removeChild(this._bg);
         }
         this._bg = this._bgList[page - 1];
         addChildAt(this._bg,0);
         this.drawLine(page,nextPointInfo,isSelf);
         this.addTotemPoint(this._totemPointLocationList[page - 1],page,nextPointInfo,isSelf);
         addChild(this._openCartoonSprite);
         addChild(this._propertyTxtSprite);
         addChild(this._chapterIcon);
         this._chapterIcon.show(page);
      }
      
      private function addTotemPoint(location:Array, page:int, nextPointInfo:TotemDataVo, isSelf:Boolean) : void
      {
         var i:int = 0;
         var tmpCell:TotemLeftWindowTotemCell = null;
         var bg:Bitmap = null;
         var icon:Bitmap = null;
         var tmpSprite:TotemLeftWindowTotemCell = null;
         if(Boolean(this._totemPointSprite))
         {
            if(this._curCanClickPointLocation != 0 && Boolean(this._totemPointList))
            {
               this._totemPointList[this._curCanClickPointLocation - 1].useHandCursor = false;
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.CLICK,this.openTotem);
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               this._curCanClickPointLocation = 0;
            }
            if(Boolean(this._totemPointSprite.parent))
            {
               this._totemPointSprite.parent.removeChild(this._totemPointSprite);
            }
            this._totemPointSprite = null;
         }
         if(Boolean(this._totemPointList))
         {
            for each(tmpCell in this._totemPointList)
            {
               tmpCell.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               tmpCell.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               ObjectUtils.disposeObject(tmpCell);
            }
            this._totemPointList = null;
         }
         this._totemPointSprite = new Sprite();
         this._totemPointList = new Vector.<TotemLeftWindowTotemCell>();
         var bgBitmapData:BitmapData = this._totemPointBgList[page - 1];
         var len:int = int(location.length);
         for(i = 0; i < len; i++)
         {
            bg = new Bitmap(bgBitmapData,"auto",true);
            icon = new Bitmap(this._totemPointIconList[i],"auto",true);
            tmpSprite = new TotemLeftWindowTotemCell(bg,icon);
            tmpSprite.x = location[i].x - 46;
            tmpSprite.y = location[i].y - 53;
            tmpSprite.addEventListener(MouseEvent.MOUSE_OVER,this.showTip,false,0,true);
            tmpSprite.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip,false,0,true);
            tmpSprite.index = i + 1;
            tmpSprite.isCurCanClick = false;
            this._totemPointSprite.addChild(tmpSprite);
            this._totemPointList.push(tmpSprite);
         }
         this._propertyTxtSprite.show(location);
         this.refreshTotemPoint(page,nextPointInfo,isSelf);
         addChild(this._totemPointSprite);
      }
      
      private function refreshGlowFilter(page:int, nextPointInfo:TotemDataVo) : void
      {
         var i:int = 0;
         var len:int = int(this._totemPointList.length);
         for(i = 0; i < len; i++)
         {
            if(!nextPointInfo || page < nextPointInfo.Page || i + 1 < nextPointInfo.Location)
            {
               this._totemPointList[i].setBgIconSpriteFilter([this._lightGlowFilter]);
               this._totemPointList[i].isHasLighted = true;
            }
            else
            {
               this._totemPointList[i].setBgIconSpriteFilter([this._grayGlowFilter]);
               this._totemPointList[i].isHasLighted = false;
            }
         }
      }
      
      private function refreshTotemPoint(page:int, nextPointInfo:TotemDataVo, isSelf:Boolean) : void
      {
         var tmpLevel:int = 0;
         var tmp:int = 0;
         var tmpLocation:int = 0;
         this.drawLine(page,nextPointInfo,isSelf);
         this.refreshGlowFilter(page,nextPointInfo);
         if(this._curCanClickPointLocation != 0)
         {
            tmp = this._curCanClickPointLocation - 1;
            this._totemPointList[tmp].dimOutHalo();
            this._totemPointList[tmp].hideLigthCross();
            this._totemPointList[tmp].removeEventListener(MouseEvent.CLICK,this.openTotem);
            this._totemPointList[tmp].useHandCursor = false;
            this._totemPointList[tmp].buttonMode = false;
            this._totemPointList[tmp].mouseChildren = true;
            this._totemPointList[tmp].mouseEnabled = true;
            this._totemPointList[tmp].isCurCanClick = false;
            this._curCanClickPointLocation = 0;
         }
         if(isSelf && nextPointInfo && page == nextPointInfo.Page)
         {
            tmpLocation = nextPointInfo.Location - 1;
            this._totemPointList[tmpLocation].brightenHalo();
            this._totemPointList[tmpLocation].showLigthCross();
            this._totemPointList[tmpLocation].useHandCursor = true;
            this._totemPointList[tmpLocation].buttonMode = true;
            this._totemPointList[tmpLocation].mouseChildren = true;
            this._totemPointList[tmpLocation].mouseEnabled = true;
            this._totemPointList[tmpLocation].addEventListener(MouseEvent.CLICK,this.openTotem,false,0,true);
            this._totemPointList[tmpLocation].isCurCanClick = true;
            this._curCanClickPointLocation = nextPointInfo.Location;
         }
         if(!nextPointInfo || page < nextPointInfo.Page)
         {
            tmpLevel = page * 10;
         }
         else
         {
            tmpLevel = (page - 1) * 10 + nextPointInfo.Layers;
         }
         this._propertyTxtSprite.refreshLayer(tmpLevel);
         var len:int = int(this._totemPointList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._totemPointList[i].level = tmpLevel;
         }
      }
      
      public function scalePropertyTxtSprite(scale:Number) : void
      {
         if(Boolean(this._propertyTxtSprite))
         {
            this._propertyTxtSprite.scaleTxt(scale);
         }
      }
      
      private function openTotem(event:MouseEvent) : void
      {
         var totemSignCount2:Number = NaN;
         var totemSignCount3:Number = NaN;
         var confirmFrame:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var nextInfo:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
         var totemSignCount:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(TotemSignTxtCell.TOTEM_SIGN,true);
         if(DragonBoatManager.instance.isBuildEnd)
         {
            totemSignCount2 = Math.round(nextInfo.DiscountMoney * (ServerConfigManager.instance.totemSignDiscount / 100));
            if(totemSignCount > totemSignCount2)
            {
               totemSignCount = totemSignCount2;
            }
            if(PlayerManager.Instance.Self.myHonor < nextInfo.ConsumeHonor || PlayerManager.Instance.Self.Money + totemSignCount < nextInfo.DiscountMoney)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorOrExpUnenough"));
               return;
            }
         }
         else
         {
            totemSignCount3 = Math.round(nextInfo.ConsumeExp * (ServerConfigManager.instance.totemSignDiscount / 100));
            if(totemSignCount > totemSignCount3)
            {
               totemSignCount = totemSignCount3;
            }
            if(PlayerManager.Instance.Self.myHonor < nextInfo.ConsumeHonor || PlayerManager.Instance.Self.Money + totemSignCount < nextInfo.ConsumeExp)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorOrExpUnenough"));
               return;
            }
         }
         if(TotemManager.instance.isSelectedActPro)
         {
            if(TotemManager.instance.isDonotPromptActPro)
            {
               if(nextInfo.Random < 100 && TotemManager.instance.isBindInNoPrompt && PlayerManager.Instance.Self.BandMoney < 1000)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
                  TotemManager.instance.isDonotPromptActPro = false;
               }
               else
               {
                  if(!(nextInfo.Random < 100 && !TotemManager.instance.isBindInNoPrompt && PlayerManager.Instance.Self.Money < 1000))
                  {
                     this.doOpenOneTotem(TotemManager.instance.isBindInNoPrompt);
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughMoneyTxt"));
                  TotemManager.instance.isDonotPromptActPro = false;
               }
            }
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.totem.activateProtectTipTxt2"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"TotemActProConfirmFrame",30,true);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__openOneTotemConfirm,false,0,true);
         }
         else
         {
            this.doOpenOneTotem(false);
         }
      }
      
      private function __openOneTotemConfirm(evt:FrameEvent) : void
      {
         var nextInfo:TotemDataVo = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__openOneTotemConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            nextInfo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            if(nextInfo.Random < 100 && confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < 1000)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.buy.noEnoughBindMoneyTxt"));
               return;
            }
            if(nextInfo.Random < 100 && !confirmFrame.isBand && PlayerManager.Instance.Self.Money < 1000)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as TotemActProConfirmFrame).isNoPrompt)
            {
               TotemManager.instance.isDonotPromptActPro = true;
               TotemManager.instance.isBindInNoPrompt = confirmFrame.isBand;
            }
            this.doOpenOneTotem(confirmFrame.isBand);
         }
      }
      
      private function doOpenOneTotem(isBind:Boolean) : void
      {
         this.disenableCurCanClickBtn();
         SocketManager.Instance.out.sendOpenOneTotem(TotemManager.instance.isSelectedActPro,isBind);
      }
      
      private function showTip(event:MouseEvent) : void
      {
         var tmpPoint:Point = null;
         var totemPoint:TotemLeftWindowTotemCell = event.currentTarget as TotemLeftWindowTotemCell;
         tmpPoint = this.localToGlobal(new Point(totemPoint.x + totemPoint.bgIconWidth + 10,totemPoint.y));
         this._tipView.x = tmpPoint.x;
         this._tipView.y = tmpPoint.y;
         var curInfo:TotemDataVo = TotemManager.instance.getCurInfoByLevel((totemPoint.level - 1) * 7 + totemPoint.index);
         this._tipView.show(curInfo,totemPoint.isCurCanClick,totemPoint.isHasLighted);
         this._tipView.visible = true;
      }
      
      private function hideTip(event:MouseEvent) : void
      {
         this._tipView.visible = false;
      }
      
      private function drawTestPoint() : void
      {
         var j:int = 0;
         var shape:Shape = new Shape();
         for(var i:int = 1; i <= 7; i++)
         {
            for(j = 1; j <= 10; j++)
            {
               shape.graphics.beginFill(16711680,0.6);
               shape.graphics.drawCircle(j * 50,i * 50,10);
               shape.graphics.endFill();
            }
         }
         addChild(shape);
      }
      
      private function drawLine(page:int, nextPointInfo:TotemDataVo, isSelf:Boolean) : void
      {
         this._lineShape.graphics.clear();
         var location:Array = this._totemPointLocationList[page - 1];
         var len:int = 0;
         if(!nextPointInfo || page < nextPointInfo.Page)
         {
            len = int(location.length);
         }
         else if(isSelf)
         {
            len = nextPointInfo.Location;
         }
         else
         {
            len = nextPointInfo.Location;
         }
         this._lineShape.graphics.lineStyle(2.7,4321279,0.2);
         this._lineShape.graphics.moveTo(location[0].x,location[0].y);
         for(var i:int = 1; i < len; i++)
         {
            this._lineShape.graphics.lineTo(location[i].x,location[i].y);
         }
         this._lineShape.filters = [new GlowFilter(65532,1,8,8)];
      }
      
      public function dispose() : void
      {
         var tmp:BitmapData = null;
         var tmp2:BitmapData = null;
         var tmpCell:TotemLeftWindowTotemCell = null;
         ObjectUtils.disposeAllChildren(this);
         for each(tmp in this._totemPointBgList)
         {
            tmp.dispose();
         }
         this._totemPointBgList = null;
         for each(tmp2 in this._totemPointIconList)
         {
            tmp2.dispose();
         }
         this._totemPointIconList = null;
         this._totemPointSprite = null;
         if(this._curCanClickPointLocation != 0 && Boolean(this._totemPointList))
         {
            this._totemPointList[this._curCanClickPointLocation - 1].useHandCursor = false;
            this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.CLICK,this.openTotem);
            this._curCanClickPointLocation = 0;
         }
         if(Boolean(this._totemPointList))
         {
            for each(tmpCell in this._totemPointList)
            {
               tmpCell.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               tmpCell.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               ObjectUtils.disposeObject(tmpCell);
            }
         }
         this._totemPointList = null;
         this._lineShape = null;
         this._lightGlowFilter = null;
         this._grayGlowFilter = null;
         this._bg = null;
         this._bgList = null;
         this._windowBorder = null;
         this._propertyTxtSprite = null;
         ObjectUtils.disposeObject(this._tipView);
         this._tipView = null;
         ObjectUtils.disposeObject(this._openCartoonSprite);
         this._openCartoonSprite = null;
         ObjectUtils.disposeObject(this._chapterIcon);
         this._chapterIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

