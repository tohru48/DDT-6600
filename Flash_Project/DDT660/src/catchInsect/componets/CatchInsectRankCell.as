package catchInsect.componets
{
   import catchInsect.data.CatchCallPropTxtTipInfo;
   import catchInsect.data.CatchInsectRankInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import newTitle.NewTitleManager;
   import vip.VipController;
   
   public class CatchInsectRankCell extends Sprite implements Disposeable
   {
      
      public static var isCatch:Boolean;
      
      private var _bg:ScaleFrameImage;
      
      private var _sprite:Sprite;
      
      private var _topThreeIcon:ScaleFrameImage;
      
      private var _placeTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _titleName:MovieClip;
      
      private var _zoneTxt:FilterFrameText;
      
      private var _info:CatchInsectRankInfo;
      
      private var _type:int;
      
      private var _collectionTypeCon:Component;
      
      public function CatchInsectRankCell(type:int)
      {
         this._type = type;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._collectionTypeCon = ComponentFactory.Instance.creatComponentByStylename("catchInsectRankCell.collectionItem.titleTipContent");
         this._topThreeIcon = ComponentFactory.Instance.creatComponentByStylename("catchInsect.topThree");
         this._topThreeIcon.visible = false;
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.placeTxt");
         this._placeTxt.text = "4th";
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.nameTxt");
         this._nameTxt.text = "小妹也带刀";
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.numTxt");
         this._numTxt.text = "10000";
         switch(this._type)
         {
            case 0:
               this._bg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.selfZoneCellBg");
               break;
            case 1:
               PositionUtils.setPos(this._nameTxt,"catchInsect.nameTxtPos");
               PositionUtils.setPos(this._numTxt,"catchInsect.numTxtPos");
               this._bg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.crossZoneCellBg");
               this._zoneTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.zoneTxt");
               this._zoneTxt.text = "七道142区";
         }
         addChild(this._bg);
         addChild(this._topThreeIcon);
         addChild(this._placeTxt);
         addChild(this._nameTxt);
         addChild(this._numTxt);
         if(Boolean(this._zoneTxt))
         {
            addChild(this._zoneTxt);
         }
      }
      
      public function setData(info:CatchInsectRankInfo) : void
      {
         var titleInfo:CatchCallPropTxtTipInfo = null;
         this._info = info;
         this._bg.setFrame(this._info.place % 2 + 1);
         if(Boolean(this._info.titleNum))
         {
            this._titleName = ComponentFactory.Instance.creat("catchInsect.title" + this._info.titleNum);
            this._titleName.scaleX = 0.7;
            this._titleName.scaleY = 0.7;
            if(Boolean(NewTitleManager.instance.titleInfo) && Boolean(NewTitleManager.instance.titleInfo[this._info.titleNum]))
            {
               isCatch = true;
               titleInfo = new CatchCallPropTxtTipInfo();
               titleInfo.Attack = NewTitleManager.instance.titleInfo[this._info.titleNum].Att;
               titleInfo.Defend = NewTitleManager.instance.titleInfo[this._info.titleNum].Def;
               titleInfo.Agility = NewTitleManager.instance.titleInfo[this._info.titleNum].Agi;
               titleInfo.Lucky = NewTitleManager.instance.titleInfo[this._info.titleNum].Luck;
               titleInfo.ValidDate = LanguageMgr.GetTranslation("CatchInsectRankCell.tip");
               this._collectionTypeCon.tipData = titleInfo;
            }
            this._collectionTypeCon.addChild(this._titleName);
            switch(this._type)
            {
               case 0:
                  PositionUtils.setPos(this._collectionTypeCon,"catchInsect.titleNamePos");
                  break;
               case 1:
                  PositionUtils.setPos(this._collectionTypeCon,"catchInsect.titleNamePos1");
            }
            addChild(this._collectionTypeCon);
         }
         this.setRankNum(this._info.place);
         this.addNickName();
         this._numTxt.text = this._info.score.toString();
         if(Boolean(this._info.area) && Boolean(this._zoneTxt))
         {
            this._zoneTxt.text = this._info.area;
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
      
      public function dispose() : void
      {
         isCatch = false;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         ObjectUtils.disposeObject(this._placeTxt);
         this._placeTxt = null;
         ObjectUtils.disposeObject(this._titleName);
         this._titleName = null;
         ObjectUtils.disposeObject(this._collectionTypeCon);
         this._collectionTypeCon = null;
         ObjectUtils.disposeObject(this._topThreeIcon);
         this._topThreeIcon = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._zoneTxt);
         this._zoneTxt = null;
      }
   }
}

