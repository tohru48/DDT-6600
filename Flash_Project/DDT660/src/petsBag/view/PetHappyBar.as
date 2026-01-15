package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import pet.date.PetInfo;
   
   public class PetHappyBar extends Component implements Disposeable
   {
      
      public static const petPercentArray:Array = ["0%","60%","80%","100%"];
      
      public static const fullHappyValue:int = 10000;
      
      private var SPACE:int = 2;
      
      private var COUNT:int = 3;
      
      private var _bgImgVec:Vector.<Bitmap>;
      
      private var _heartImgVec:Vector.<Bitmap>;
      
      private var _info:PetInfo;
      
      private var _lv:Bitmap;
      
      private var _lvTxt:FilterFrameText;
      
      public function PetHappyBar()
      {
         super();
         this._bgImgVec = new Vector.<Bitmap>();
         this._heartImgVec = new Vector.<Bitmap>();
         this.initView();
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(value:PetInfo) : void
      {
         this._info = value;
         this.tipData = this._info;
         this.happyStatus = Boolean(this._info) ? this._info.PetHappyStar : 0;
         this._lvTxt.text = Boolean(this._info) ? this._info.Level.toString() : "";
      }
      
      private function gapWidth() : Number
      {
         return this._lvTxt.x + 28;
      }
      
      private function initView() : void
      {
         var img:Bitmap = null;
         this._lv = ComponentFactory.Instance.creatBitmap("assets.petsBag.Lv");
         addChild(this._lv);
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.Lv");
         addChild(this._lvTxt);
         for(var index:int = 0; index < this.COUNT; index++)
         {
            img = ComponentFactory.Instance.creatBitmap("assets.petsBag.heart1");
            this._bgImgVec.push(img);
            addChild(img);
            img.x = this.gapWidth() + 2 + index * img.width + this.SPACE;
         }
      }
      
      private function set happyStatus(type:int) : void
      {
         if(type > 0)
         {
            if(type > this.COUNT)
            {
               type = this.COUNT;
            }
            this.update(type);
         }
         else
         {
            this.remove();
         }
      }
      
      private function update(count:int) : void
      {
         var img:Bitmap = null;
         this.remove();
         for(var index:int = 0; index < count; index++)
         {
            img = ComponentFactory.Instance.creatBitmap("assets.petsBag.heart2");
            this._heartImgVec.push(img);
            addChild(img);
            img.x = this.gapWidth() + 2 + index * img.width + this.SPACE;
         }
      }
      
      private function remove() : void
      {
         var index:int = 0;
         var count:int = int(this._heartImgVec.length);
         for(index = 0; index < count; index++)
         {
            ObjectUtils.disposeObject(this._heartImgVec[index]);
         }
         this._heartImgVec.splice(0,this._heartImgVec.length);
      }
      
      override public function dispose() : void
      {
         this.remove();
         this._heartImgVec = null;
         for(var index:int = 0; index < this.COUNT; index++)
         {
            ObjectUtils.disposeObject(this._bgImgVec[index]);
         }
         this._bgImgVec.splice(0,this._bgImgVec.length);
         this._bgImgVec = null;
         if(Boolean(this._lvTxt))
         {
            ObjectUtils.disposeObject(this._lvTxt);
            this._lvTxt = null;
         }
         if(Boolean(this._lv))
         {
            ObjectUtils.disposeObject(this._lv);
            this._lv = null;
         }
         super.dispose();
      }
   }
}

