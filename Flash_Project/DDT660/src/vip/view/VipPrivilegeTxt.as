package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class VipPrivilegeTxt extends Sprite implements Disposeable
   {
      
      private var _content:TextArea;
      
      public function VipPrivilegeTxt()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._content = ComponentFactory.Instance.creatComponentByStylename("VipPrivilegeLV.propArea");
         addChild(this._content);
      }
      
      public function set AlertContent(_vipLev:int) : void
      {
         this._content.setView(this.getAlerTxt(_vipLev));
         this._content.invalidateViewport();
      }
      
      private function getAlerTxt(lev:int) : MovieImage
      {
         var resultString:MovieImage = new MovieImage();
         switch(lev)
         {
            case 1:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt1");
               break;
            case 2:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt2");
               break;
            case 3:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt3");
               break;
            case 4:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt4");
               break;
            case 5:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt5");
               break;
            case 6:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt6");
               break;
            case 7:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt7");
               break;
            case 8:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt8");
               break;
            case 9:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt9");
               break;
            case 10:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt10");
               break;
            case 11:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt11");
               break;
            case 12:
               resultString = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeTxt12");
         }
         return resultString;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
      }
   }
}

