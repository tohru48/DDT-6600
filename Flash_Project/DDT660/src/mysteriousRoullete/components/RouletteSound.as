package mysteriousRoullete.components
{
   import ddt.manager.SoundManager;
   
   public class RouletteSound
   {
      
      private var _oneArray:Array = ["130","131","133","132","135","134","129","128","127","132","135","134","129","128","127"];
      
      private var _number:int = 0;
      
      public function RouletteSound()
      {
         super();
      }
      
      public function playOneStep() : void
      {
         var id:String = this._oneArray[this._number];
         SoundManager.instance.play(id);
         this._number = this._number >= 4 ? 0 : this._number + 1;
      }
   }
}

