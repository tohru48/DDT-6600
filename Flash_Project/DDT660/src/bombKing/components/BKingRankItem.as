package bombKing.components
{
   import bombKing.data.BKingRankInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class BKingRankItem extends Sprite implements Disposeable
   {
      
      private var _sprite:Sprite;
      
      private var _backOverImg:Scale9CornerImage;
      
      private var _topThreeIcon:ScaleFrameImage;
      
      private var _placeTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _areaName:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _info:BKingRankInfo;
      
      public function BKingRankItem()
      {
         super();
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         this._backOverImg = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankFrame.mouseOver");
         this._backOverImg.visible = false;
         this._sprite = new Sprite();
         this._sprite.graphics.beginFill(0,0);
         this._sprite.graphics.drawRect(0,0,this._backOverImg.width,this._backOverImg.height);
         this._sprite.graphics.endFill();
         this._sprite.x = this._backOverImg.x;
         this._sprite.y = this._backOverImg.y;
         addChild(this._sprite);
         this._topThreeIcon = ComponentFactory.Instance.creatComponentByStylename("bombKing.topThree");
         addChild(this._topThreeIcon);
         this._topThreeIcon.visible = false;
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankVeiw.placeTxt");
         addChild(this._placeTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankVeiw.nameTxt");
         addChild(this._nameTxt);
         this._areaName = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankVeiw.areaName");
         addChild(this._areaName);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("bombKing.rankVeiw.numTxt");
         addChild(this._numTxt);
         addChild(this._backOverImg);
      }
      
      private function addEvents() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         addEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
      }
      
      protected function __onOutHandler(event:MouseEvent) : void
      {
         this._backOverImg.visible = false;
      }
      
      protected function __onOverHanlder(event:MouseEvent) : void
      {
         this._backOverImg.visible = true;
      }
      
      public function set info(info:BKingRankInfo) : void
      {
         this._info = info;
         this.setRankNum(this._info.place);
         this.addNickName();
         this._areaName.text = this._info.areaName;
         this._numTxt.text = this._info.num + "";
      }
      
      private function addNickName() : void
      {
         var textFormat:TextFormat = null;
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         this._nameTxt.visible = !this._info.isVIP;
         if(this._info.isVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(1,1);
            textFormat = new TextFormat();
            textFormat.align = "center";
            textFormat.bold = true;
            this._vipName.textField.defaultTextFormat = textFormat;
            this._vipName.textSize = 16;
            this._vipName.textField.width = this._nameTxt.width;
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._info.name;
            addChild(this._vipName);
         }
         else
         {
            this._nameTxt.text = this._info.name;
         }
      }
      
      private function setRankNum(num:int) : void
      {
         if(num <= 3)
         {
            this._placeTxt.visible = false;
            this._topThreeIcon.visible = true;
            this._topThreeIcon.setFrame(num);
         }
         else
         {
            this._placeTxt.visible = true;
            this._topThreeIcon.visible = false;
            this._placeTxt.text = num + "th";
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._sprite);
         this._sprite = null;
         ObjectUtils.disposeObject(this._backOverImg);
         this._backOverImg = null;
         ObjectUtils.disposeObject(this._placeTxt);
         this._placeTxt = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._areaName);
         this._areaName = null;
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         ObjectUtils.disposeObject(this._topThreeIcon);
         this._topThreeIcon = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
      }
   }
}

