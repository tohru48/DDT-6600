package magicStone.components
{
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class EmbedMgStoneCell extends MgStoneCell
   {
      
      public function EmbedMgStoneCell(index:int = 0, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:DisplayObject = null)
      {
         super(index,info,showLoading,bg);
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         if(Boolean(value) && Boolean(_nameTxt))
         {
            _nameTxt.x = -1;
            _nameTxt.y = 37;
            _nameTxt.width = 60;
            _nameTxt.height = 18;
            _nameTxt.filterString = "magicStone.mgStoneCell.nameGF2";
            _nameTxt.text = _info.Name.substr(0,2) + "Lv." + _info.Level;
            _nameTxt.textColor = this.getNameTxtColor(_info.Quality);
         }
      }
      
      private function getNameTxtColor(quality:int) : uint
      {
         switch(quality)
         {
            case 1:
               return 11655167;
            case 2:
               return 65280;
            case 3:
               return 57087;
            case 4:
               return 16729855;
            case 5:
               return 16771584;
            case 6:
               return 16711680;
            default:
               return 0;
         }
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.scaleX = 0.7;
            sp.scaleY = 0.7;
            sp.x = sp.x - sp.width / 2 + _contentWidth / 2;
            sp.y = sp.y - sp.height / 2 + _contentHeight / 2;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

