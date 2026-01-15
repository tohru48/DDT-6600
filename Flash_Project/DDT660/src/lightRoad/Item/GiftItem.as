package lightRoad.Item
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import lightRoad.info.LightGiftInfo;
   import lightRoad.manager.LightRoadManager;
   
   public class GiftItem extends Sprite implements Disposeable
   {
      
      private var _index:int = 0;
      
      private var _baseCell:BaseCell;
      
      private var _MaskMC:MovieClip;
      
      private var _numberText:FilterFrameText;
      
      private var _GiftMessage:LightGiftInfo;
      
      private var _activationBtn:BaseButton;
      
      private var _drawBtn:BaseButton;
      
      private var _branchMC:MovieClip;
      
      public function GiftItem(index:int)
      {
         super();
         this._index = index;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function initItemCell(GiftMessage:LightGiftInfo) : void
      {
         var point:Point = null;
         this.disposeCell();
         this._GiftMessage = GiftMessage;
         if(this._GiftMessage.Type == 0)
         {
            this._baseCell = this.creatItemCell();
         }
         else
         {
            this._baseCell = this.creatItemCell(60);
            point = PositionUtils.creatPoint("light.giftItem.Pos2");
            this._baseCell.x = point.x;
            this._baseCell.y = point.y;
         }
         this._baseCell.info = this.GetTemplateInfo(this._GiftMessage.TemplateID);
         this._baseCell.info.ThingsFrom = this._GiftMessage.GetFrom;
         addChild(this._baseCell);
         this.upData();
      }
      
      public function upData() : void
      {
         this.removeNumberMC();
         this.removeMaskMC();
         this.removeActivationBtn();
         this.removeDrawBtn();
         this.removeBranchMC();
         if(this._GiftMessage.Type == 1)
         {
            this._MaskMC = ComponentFactory.Instance.creat("asset.lightroad.swf.circularMask");
            addChild(this._MaskMC);
            this._baseCell.mask = this._MaskMC;
            this._numberText = ComponentFactory.Instance.creatComponentByStylename("lightRoad.gift.Number2Txt");
            this._numberText.text = String(this._GiftMessage.Count);
            if(this._GiftMessage.Count == 1)
            {
               this._numberText.visible = false;
            }
            if(this._GiftMessage.GetType == 0)
            {
               this.checkPointNoDrawType();
            }
            else
            {
               this._baseCell.filters = [];
               this._numberText.visible = false;
            }
         }
         else
         {
            this._numberText = ComponentFactory.Instance.creatComponentByStylename("lightRoad.gift.Number1Txt");
            if(this._GiftMessage.GetType == 0)
            {
               this.checkBranchNoDrawType();
            }
            else
            {
               this._baseCell.filters = [];
               this._numberText.visible = false;
            }
         }
         addChild(this._numberText);
      }
      
      private function checkPointNoDrawType() : void
      {
         var i:int = 0;
         var len1:int = 0;
         var j:int = 0;
         var len2:int = 0;
         var canDraw:Boolean = true;
         var tempSpace:int = 0;
         len1 = int(LightRoadManager.instance.model.pointGroup.length);
         for(i = 0; i < len1; i++)
         {
            if(this._GiftMessage.Space == LightRoadManager.instance.model.pointGroup[i][0])
            {
               len2 = int(LightRoadManager.instance.model.pointGroup[i][1].length);
               for(j = 0; j < len2; j++)
               {
                  tempSpace = LightRoadManager.instance.model.pointGroup[i][1][j] - 1;
                  if(LightRoadManager.instance.model.thingsType[tempSpace] == 0)
                  {
                     canDraw = false;
                     break;
                  }
               }
               break;
            }
         }
         if(canDraw)
         {
            this._baseCell.filters = [];
            this._branchMC = ComponentFactory.Instance.creat("asset.lightroad.swf.Branch.mc");
            this._branchMC.x = 25;
            this._branchMC.y = 25;
            addChild(this._branchMC);
            this._drawBtn = ComponentFactory.Instance.creat("lightRoad.Gift.draw.btn");
            addChild(this._drawBtn);
            this._drawBtn.addEventListener(MouseEvent.CLICK,this.__draw);
         }
         else
         {
            this._baseCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
         }
      }
      
      private function checkBranchNoDrawType() : void
      {
         var tempN:int = 0;
         tempN = 0;
         var TemplateID:int = this._GiftMessage.TemplateID;
         tempN = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(TemplateID);
         if(tempN == 0)
         {
            tempN = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(TemplateID);
         }
         if(tempN == 0)
         {
            tempN = PlayerManager.Instance.Self.FightBag.getItemCountByTemplateId(TemplateID);
         }
         if(tempN == 0)
         {
            tempN = PlayerManager.Instance.Self.TempBag.getItemCountByTemplateId(TemplateID);
         }
         if(tempN == 0)
         {
            tempN = PlayerManager.Instance.Self.CaddyBag.getItemCountByTemplateId(TemplateID);
         }
         if(tempN == 0)
         {
            tempN = PlayerManager.Instance.Self.farmBag.getItemCountByTemplateId(TemplateID);
         }
         if(tempN == 0)
         {
            tempN = PlayerManager.Instance.Self.vegetableBag.getItemCountByTemplateId(TemplateID);
         }
         if(tempN >= this._GiftMessage.Count)
         {
            this._baseCell.filters = [];
            this._branchMC = ComponentFactory.Instance.creat("asset.lightroad.swf.Branch.mc");
            this._branchMC.x = 25;
            this._branchMC.y = 25;
            addChild(this._branchMC);
            this._activationBtn = ComponentFactory.Instance.creat("lightRoad.Gift.activation.btn");
            addChild(this._activationBtn);
            this._activationBtn.addEventListener(MouseEvent.CLICK,this.__activation);
            this._numberText.text = tempN + "/" + this._GiftMessage.Count;
         }
         else
         {
            this._baseCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            this._numberText.text = tempN + "/" + this._GiftMessage.Count;
         }
      }
      
      private function __draw(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LightRoadManager.instance.DrawThings(this._GiftMessage.Space);
      }
      
      private function __activation(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LightRoadManager.instance.DrawThings(this._GiftMessage.Space);
      }
      
      protected function creatItemCell(W:int = 50) : BaseCell
      {
         var cell:BaseCell = null;
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,W,W);
         sp.graphics.endFill();
         cell = new BaseCell(sp,null,true,true);
         cell.tipDirctions = "1,5,4,0,3,7,6,2";
         cell.tipGapV = 10;
         cell.tipGapH = 10;
         cell.tipStyle = "core.GoodsTip";
         return cell;
      }
      
      public function GetTemplateInfo(TemplateID:int) : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(TemplateID);
      }
      
      private function removeActivationBtn() : void
      {
         if(Boolean(this._activationBtn))
         {
            this._activationBtn.removeEventListener(MouseEvent.CLICK,this.__activation);
            ObjectUtils.disposeObject(this._activationBtn);
            this._activationBtn = null;
         }
      }
      
      private function removeDrawBtn() : void
      {
         if(Boolean(this._drawBtn))
         {
            this._drawBtn.removeEventListener(MouseEvent.CLICK,this.__draw);
            ObjectUtils.disposeObject(this._drawBtn);
            this._drawBtn = null;
         }
      }
      
      private function removeBranchMC() : void
      {
         if(Boolean(this._branchMC))
         {
            ObjectUtils.disposeObject(this._branchMC);
            this._branchMC = null;
         }
      }
      
      private function removeNumberMC() : void
      {
         if(Boolean(this._numberText))
         {
            ObjectUtils.disposeObject(this._numberText);
            this._numberText = null;
         }
      }
      
      private function removeMaskMC() : void
      {
         if(Boolean(this._MaskMC))
         {
            ObjectUtils.disposeObject(this._MaskMC);
            this._MaskMC = null;
         }
      }
      
      private function disposeCell() : void
      {
         this.removeBranchMC();
         if(Boolean(this._baseCell))
         {
            ObjectUtils.disposeObject(this._baseCell);
            this._baseCell = null;
         }
         this.removeMaskMC();
         this.removeActivationBtn();
         this.removeDrawBtn();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeCell();
      }
   }
}

