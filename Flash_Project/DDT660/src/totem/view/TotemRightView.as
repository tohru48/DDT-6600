package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemRightView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _lvTxt:FilterFrameText;
      
      private var _titleTxt1:FilterFrameText;
      
      private var _honorTxt1:TotemRightViewIconTxtCell;
      
      private var _expTxt1:TotemRightViewIconTxtCell;
      
      private var _titleTxt2:FilterFrameText;
      
      private var _honorTxt2:TotemRightViewIconTxtCell;
      
      private var _expTxt2:TotemRightViewIconTxtCell;
      
      private var _titleTxt3:FilterFrameText;
      
      private var _propertyList:Vector.<TotemRightViewTxtTxtCell>;
      
      private var _tipTxt:FilterFrameText;
      
      private var _honorUpIcon:HonorUpIcon;
      
      private var _nextInfo:TotemDataVo;
      
      private var _totemRightViewIconTxtDragonBoatCell:TotemRightViewIconTxtDragonBoatCell;
      
      private var _totemSignTxt:FilterFrameText;
      
      private var _totemSignTxtCell:TotemSignTxtCell;
      
      public function TotemRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:TotemRightViewTxtTxtCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.bg");
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.lvTxt");
         this._titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.titleTxt1");
         this._titleTxt1.text = LanguageMgr.GetTranslation("ddt.totem.rightView.titleTxt1");
         this._honorTxt1 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.honor1");
         this._expTxt1 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.exp1");
         this._titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.titleTxt2");
         this._titleTxt2.text = LanguageMgr.GetTranslation("ddt.totem.rightView.titleTxt2");
         this._honorTxt2 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.honor2");
         this._expTxt2 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.exp2");
         this._titleTxt3 = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.titleTxt3");
         this._titleTxt3.text = LanguageMgr.GetTranslation("ddt.totem.rightView.titleTxt3");
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.tipTxt");
         this._tipTxt.text = LanguageMgr.GetTranslation("ddt.totem.rightView.tipTxt");
         this._honorUpIcon = ComponentFactory.Instance.creatCustomObject("totem.honorUpIcon");
         this._totemSignTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.totemSignTxt");
         this._totemSignTxtCell = ComponentFactory.Instance.creatCustomObject("totem.totemSignTxtCell");
         addChild(this._bg);
         addChild(this._lvTxt);
         addChild(this._titleTxt1);
         addChild(this._honorTxt1);
         addChild(this._expTxt1);
         addChild(this._titleTxt2);
         addChild(this._honorTxt2);
         addChild(this._expTxt2);
         addChild(this._titleTxt3);
         addChild(this._tipTxt);
         this._propertyList = new Vector.<TotemRightViewTxtTxtCell>();
         for(i = 1; i <= 7; i++)
         {
            tmp = ComponentFactory.Instance.creatCustomObject("TotemRightViewTxtTxtCell" + i);
            tmp.show(i);
            tmp.x = 44 + (i - 1) % 2 * 110;
            tmp.y = 328 + int((i - 1) / 2) * 21;
            addChild(tmp);
            this._propertyList.push(tmp);
         }
         addChild(this._honorUpIcon);
         addChild(this._totemSignTxt);
         addChild(this._totemSignTxtCell);
         this._honorTxt1.show(2);
         this._expTxt1.show(1);
         this._honorTxt2.show(2);
         this._expTxt2.show(1);
         this.refreshView();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
      }
      
      public function refreshView() : void
      {
         var totemSignCount:Number = NaN;
         this._totemSignTxtCell.updateData();
         var curLv:int = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
         this._lvTxt.text = LanguageMgr.GetTranslation("ddt.totem.rightView.lvTxt",TotemManager.instance.getCurrentLv(curLv));
         this._nextInfo = TotemManager.instance.getNextInfoByLevel(curLv);
         if(Boolean(this._nextInfo))
         {
            this._honorTxt1.refresh(this._nextInfo.ConsumeHonor);
            this._expTxt1.refresh(this._nextInfo.ConsumeExp);
            totemSignCount = Math.round(this._nextInfo.ConsumeExp * (ServerConfigManager.instance.totemSignDiscount / 100));
            if(DragonBoatManager.instance.isBuildEnd)
            {
               this._expTxt1.rawTextLine();
               if(!this._totemRightViewIconTxtDragonBoatCell)
               {
                  this._totemRightViewIconTxtDragonBoatCell = ComponentFactory.Instance.creatCustomObject("totem.rightView.iconCellDragonBoat");
                  addChild(this._totemRightViewIconTxtDragonBoatCell);
               }
               this._totemRightViewIconTxtDragonBoatCell.refresh(this._nextInfo.DiscountMoney);
               totemSignCount = Math.round(this._nextInfo.DiscountMoney * (ServerConfigManager.instance.totemSignDiscount / 100));
            }
            else
            {
               this._expTxt1.clearTextLine();
            }
            this._totemSignTxt.htmlText = LanguageMgr.GetTranslation("ddt.totem.rightViewTotemSignTxt",totemSignCount,totemSignCount);
         }
         else
         {
            this._honorTxt1.refresh(0);
            this._expTxt1.refresh(0);
         }
         this.refreshHonorTxt();
         this.refreshGPTxt();
         for(var i:int = 0; i < 7; i++)
         {
            this._propertyList[i].refresh();
         }
      }
      
      private function refreshHonorTxt() : void
      {
         var isChangeColor:Boolean = false;
         if(Boolean(this._nextInfo) && PlayerManager.Instance.Self.myHonor < this._nextInfo.ConsumeHonor)
         {
            isChangeColor = true;
         }
         var myhhonor:int = PlayerManager.Instance.Self.myHonor;
         this._honorTxt2.refresh(PlayerManager.Instance.Self.myHonor,isChangeColor);
      }
      
      private function refreshGPTxt() : void
      {
         var isChangeColor:Boolean = false;
         var totemSignCount:int = 0;
         var totemSignCount2:Number = NaN;
         var totemSignCount3:Number = NaN;
         if(Boolean(this._nextInfo))
         {
            isChangeColor = false;
            totemSignCount = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(TotemSignTxtCell.TOTEM_SIGN,true);
            if(DragonBoatManager.instance.isBuildEnd)
            {
               totemSignCount2 = Math.round(this._nextInfo.DiscountMoney * (ServerConfigManager.instance.totemSignDiscount / 100));
               if(totemSignCount > totemSignCount2)
               {
                  totemSignCount = totemSignCount2;
               }
               if(Boolean(this._nextInfo) && PlayerManager.Instance.Self.Money + totemSignCount < this._nextInfo.DiscountMoney)
               {
                  isChangeColor = true;
               }
            }
            else
            {
               totemSignCount3 = Math.round(this._nextInfo.ConsumeExp * (ServerConfigManager.instance.totemSignDiscount / 100));
               if(totemSignCount > totemSignCount3)
               {
                  totemSignCount = totemSignCount3;
               }
               if(Boolean(this._nextInfo) && PlayerManager.Instance.Self.Money + totemSignCount < this._nextInfo.ConsumeExp)
               {
                  isChangeColor = true;
               }
            }
            this._expTxt2.refresh(PlayerManager.Instance.Self.Money,isChangeColor);
         }
         else
         {
            this._expTxt2.refresh(PlayerManager.Instance.Self.Money,false);
         }
      }
      
      private function propertyChangeHandler(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["myHonor"]))
         {
            this.refreshHonorTxt();
         }
         if(Boolean(event.changedProperties["GP"]))
         {
            this.refreshGPTxt();
         }
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._totemSignTxt);
         this._totemSignTxt = null;
         ObjectUtils.disposeAllChildren(this._totemSignTxtCell);
         ObjectUtils.disposeObject(this._totemSignTxtCell);
         this._totemSignTxtCell = null;
         ObjectUtils.disposeAllChildren(this);
         this._nextInfo = null;
         this._bg = null;
         this._lvTxt = null;
         this._titleTxt1 = null;
         this._honorTxt1 = null;
         this._expTxt1 = null;
         this._titleTxt2 = null;
         this._honorTxt2 = null;
         this._expTxt2 = null;
         this._titleTxt3 = null;
         this._tipTxt = null;
         this._propertyList = null;
         this._honorUpIcon = null;
         this._totemRightViewIconTxtDragonBoatCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

