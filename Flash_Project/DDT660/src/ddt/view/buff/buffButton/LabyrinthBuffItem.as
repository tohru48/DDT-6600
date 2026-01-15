package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import game.view.propertyWaterBuff.PropertyWaterBuffIcon;
   
   public class LabyrinthBuffItem extends Sprite implements Disposeable
   {
      
      private var _iconList:Vector.<PropertyWaterBuffIcon>;
      
      private var _buffDesc:Vector.<FilterFrameText>;
      
      public function LabyrinthBuffItem(buffInfo:BuffInfo)
      {
         super();
         this._iconList = new Vector.<PropertyWaterBuffIcon>();
         this._buffDesc = new Vector.<FilterFrameText>();
         this.initView(buffInfo);
      }
      
      private function initView(buffInfo:BuffInfo) : void
      {
         var buffDesc:FilterFrameText = null;
         var icon:PropertyWaterBuffIcon = ComponentFactory.Instance.creat("game.view.propertyWaterBuff.propertyWaterBuffIcon",[buffInfo]);
         this._iconList.push(icon);
         addChild(icon);
         buffDesc = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.GesteField");
         var time:int = (icon.tipData as BuffInfo).getLeftTimeByUnit(TimeManager.DAY_TICKS) * 24 * 60 + (icon.tipData as BuffInfo).getLeftTimeByUnit(TimeManager.HOUR_TICKS) * 60 + (icon.tipData as BuffInfo).getLeftTimeByUnit(TimeManager.Minute_TICKS);
         buffDesc.text = LanguageMgr.GetTranslation("game.view.propertyWaterBuff.timerII",time);
         buffDesc.x = icon.x + 47;
         buffDesc.y = icon.y + 7;
         this._buffDesc.push(buffDesc);
         addChild(buffDesc);
      }
      
      public function dispose() : void
      {
         var icon:PropertyWaterBuffIcon = null;
         var buffTxt:FilterFrameText = null;
         for each(icon in this._iconList)
         {
            ObjectUtils.disposeObject(icon);
            icon = null;
         }
         for each(buffTxt in this._buffDesc)
         {
            ObjectUtils.disposeObject(buffTxt);
            buffTxt = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

