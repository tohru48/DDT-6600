package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class TotemLeftWindowPropertyTxtView extends Sprite implements Disposeable
   {
      
      private var _levelTxtList:Vector.<FilterFrameText>;
      
      private var _txtArray:Array;
      
      public function TotemLeftWindowPropertyTxtView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._levelTxtList = new Vector.<FilterFrameText>();
         for(var i:int = 1; i <= 7; i++)
         {
            this._levelTxtList.push(ComponentFactory.Instance.creatComponentByStylename("totem.totemWindow.propertyName" + i));
         }
         var tmp:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = tmp.split(",");
      }
      
      public function show(location:Array) : void
      {
         var i:int = 0;
         for(i = 0; i < 7; i++)
         {
            this._levelTxtList[i].x = location[i].x - 45;
            this._levelTxtList[i].y = location[i].y + 22;
            addChild(this._levelTxtList[i]);
         }
      }
      
      public function refreshLayer(level:int) : void
      {
         for(var i:int = 0; i < 7; i++)
         {
            this._levelTxtList[i].text = LanguageMgr.GetTranslation("ddt.totem.totemWindow.propertyLvTxt",level,this._txtArray[i]);
         }
      }
      
      public function scaleTxt(scale:Number) : void
      {
         var i:int = 0;
         if(!this._levelTxtList)
         {
            return;
         }
         var len:int = int(this._levelTxtList.length);
         for(i = 0; i < len; i++)
         {
            this._levelTxtList[i].scaleX = scale;
            this._levelTxtList[i].scaleY = scale;
            this._levelTxtList[i].x -= 5;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._levelTxtList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

