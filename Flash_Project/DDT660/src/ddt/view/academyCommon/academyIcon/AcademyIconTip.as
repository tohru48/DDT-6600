package ddt.view.academyCommon.academyIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class AcademyIconTip extends Sprite implements Disposeable, ITip
   {
      
      public static const MAX_HEIGHT:int = 70;
      
      public static const MIN_HEIGHT:int = 22;
      
      private var _tipData:PlayerInfo;
      
      private var _contentLabel:TextFormat;
      
      private var _bg:ScaleBitmapImage;
      
      private var _textFrameArray:Vector.<FilterFrameText>;
      
      public function AcademyIconTip()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.academyIconTipsBG");
         addChild(this._bg);
         this._textFrameArray = new Vector.<FilterFrameText>();
         var _content:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.contentTxt");
         addChild(_content);
         this._textFrameArray.push(_content);
         var _contentII:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.contentTxtII");
         addChild(_contentII);
         this._textFrameArray.push(_contentII);
         var _contentIII:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.contentTxtIII");
         addChild(_contentIII);
         this._textFrameArray.push(_contentIII);
         this._contentLabel = ComponentFactory.Instance.model.getSet("academyCommon.academyIcon.contentLabelTF");
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(data:Object) : void
      {
         this._tipData = data as PlayerInfo;
         if(Boolean(this._tipData))
         {
            this.update();
         }
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function update() : void
      {
         var i:int = 0;
         var num:int = 0;
         var number:int = 0;
         var isSelf:Boolean = PlayerManager.Instance.Self.ID == this._tipData.ID;
         this._textFrameArray[0].visible = this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         if(this._tipData.apprenticeshipState == AcademyManager.MASTER_STATE || this._tipData.apprenticeshipState == AcademyManager.MASTER_FULL_STATE)
         {
            for(i = 0; i <= (this._tipData.getMasterOrApprentices().length >= 3 ? 2 : this._tipData.getMasterOrApprentices().length); i++)
            {
               if(Boolean(this._tipData.getMasterOrApprentices().list[i]) && this._tipData.getMasterOrApprentices().list[i] != "")
               {
                  this._textFrameArray[i].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.master",this._tipData.getMasterOrApprentices().list[i]);
                  this._textFrameArray[i].setTextFormat(this._contentLabel,this._textFrameArray[i].text.indexOf(this._tipData.getMasterOrApprentices().list[i]),this._textFrameArray[i].text.indexOf(this._tipData.getMasterOrApprentices().list[i]) + this._tipData.getMasterOrApprentices().list[i].length);
                  this._textFrameArray[i].visible = true;
               }
               else
               {
                  num = 3 - this._tipData.getMasterOrApprentices().length;
                  this._textFrameArray[i].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.masterExplanation",num);
                  this._textFrameArray[i].visible = true;
               }
            }
         }
         else if(this._tipData.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
         {
            if(Boolean(this._tipData.getMasterOrApprentices().list[0]) && this._tipData.getMasterOrApprentices().list[0] != "")
            {
               this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.Apprentice",this._tipData.getMasterOrApprentices().list[0]);
               this._textFrameArray[0].setTextFormat(this._contentLabel,this._textFrameArray[0].text.indexOf(this._tipData.getMasterOrApprentices().list[0]),this._textFrameArray[0].text.indexOf(this._tipData.getMasterOrApprentices().list[0]) + this._tipData.getMasterOrApprentices().list[0].length);
               this._textFrameArray[0].visible = true;
            }
            else if(!isSelf)
            {
               this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.ApprenticeExplanation");
               this._textFrameArray[0].visible = true;
            }
            this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         }
         else if(this._tipData.ID == PlayerManager.Instance.Self.ID && this._tipData.apprenticeshipState == AcademyManager.NONE_STATE)
         {
            this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.ApprenticeNull");
            this._textFrameArray[0].visible = true;
            this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         }
         else
         {
            if(this._tipData.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
            {
               if(!isSelf)
               {
                  number = 3 - this._tipData.getMasterOrApprentices().length;
                  this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.masterExplanation",number);
                  this._textFrameArray[0].visible = true;
               }
            }
            else if(!isSelf)
            {
               this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.ApprenticeExplanation");
               this._textFrameArray[0].visible = true;
            }
            this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         }
         this.updateBgSize();
      }
      
      private function updateBgSize() : void
      {
         var isSelf:Boolean = PlayerManager.Instance.Self.ID == this._tipData.ID;
         this._bg.width = this.getMaxWidth();
         var length:int = 0;
         for(var i:int = 0; i < this._textFrameArray.length; i++)
         {
            if(this._textFrameArray[i].visible)
            {
               length++;
            }
         }
         this._bg.height = length * MIN_HEIGHT;
      }
      
      private function getApprenticesNum() : String
      {
         var num:int = 3 - this._tipData.getMasterOrApprentices().length;
         switch(num)
         {
            case 1:
               return LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.1");
            case 2:
               return LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.2");
            case 3:
               return LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.3");
            default:
               return "";
         }
      }
      
      private function getMaxWidth() : int
      {
         var maxWidth:int = 0;
         for(var i:int = 0; i < this._textFrameArray.length; i++)
         {
            if(this._textFrameArray[i].visible && this._textFrameArray[i].width > maxWidth)
            {
               maxWidth = this._textFrameArray[i].width;
            }
         }
         return maxWidth + 10;
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         if(Boolean(this._textFrameArray))
         {
            for(i = 0; i < this._textFrameArray.length; i++)
            {
               this._textFrameArray[i].dispose();
               this._textFrameArray[i] = null;
            }
         }
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         this._contentLabel = null;
      }
   }
}

