package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class TofflistTitleInfoItem extends Sprite
   {
      
      protected var _title:FilterFrameText;
      
      protected var _requireText:FilterFrameText;
      
      protected var _contentText:FilterFrameText;
      
      protected var _title1:FilterFrameText;
      
      protected var _title2:FilterFrameText;
      
      protected var _title3:FilterFrameText;
      
      protected var _title4:FilterFrameText;
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      public function TofflistTitleInfoItem()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._title = ComponentFactory.Instance.creatComponentByStylename("toffilist.titleInfoTxt");
         this._title.text = LanguageMgr.GetTranslation("toffilist.titleInfo.leftTitleText");
         addChild(this._title);
         this._requireText = ComponentFactory.Instance.creatComponentByStylename("toffilist.require");
         this._requireText.text = LanguageMgr.GetTranslation("toffilist.titleInfo.requireText");
         addChild(this._requireText);
         this._contentText = ComponentFactory.Instance.creatComponentByStylename("toffilist.content");
         this._contentText.text = LanguageMgr.GetTranslation("toffilist.titleInfo.leftContentText");
         addChild(this._contentText);
         this._title1 = ComponentFactory.Instance.creatComponentByStylename("toffilist.titleTxt1");
         this._title1.text = LanguageMgr.GetTranslation("hall.player.titleText0");
         addChild(this._title1);
         this._title2 = ComponentFactory.Instance.creatComponentByStylename("toffilist.titleTxt2");
         this._title2.text = LanguageMgr.GetTranslation("hall.player.titleText1");
         addChild(this._title2);
         this._title3 = ComponentFactory.Instance.creatComponentByStylename("toffilist.titleTxt3");
         this._title3.text = LanguageMgr.GetTranslation("hall.player.titleText2");
         addChild(this._title3);
         this._title4 = ComponentFactory.Instance.creatComponentByStylename("toffilist.titleTxt4");
         this._title4.text = LanguageMgr.GetTranslation("hall.player.titleText7");
         addChild(this._title4);
      }
      
      public function setData(data:Object) : void
      {
         this._title.text = data.titleText;
         this._contentText.text = data.content;
         this._requireText.text = data.rightRequiredText;
         this._title1.textFormatStyle = data.title1;
         this._title2.textFormatStyle = data.title2;
         this._title3.textFormatStyle = data.title3;
         this._title4.textFormatStyle = data.title4;
         this._title1.text = data.titleName1;
         this._title2.text = data.titleName2;
         this._title3.text = data.titleName3;
         this._title4.text = data.titleName4;
         this._title1.x = this._title2.x;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._requireText))
         {
            ObjectUtils.disposeObject(this._requireText);
         }
         this._requireText = null;
         if(Boolean(this._contentText))
         {
            ObjectUtils.disposeObject(this._contentText);
         }
         this._contentText = null;
         if(Boolean(this._title1))
         {
            ObjectUtils.disposeObject(this._title1);
         }
         this._title1 = null;
         if(Boolean(this._title2))
         {
            ObjectUtils.disposeObject(this._title2);
         }
         this._title2 = null;
         if(Boolean(this._title3))
         {
            ObjectUtils.disposeObject(this._title3);
         }
         this._title3 = null;
         if(Boolean(this._title4))
         {
            ObjectUtils.disposeObject(this._title4);
         }
         this._title4 = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

