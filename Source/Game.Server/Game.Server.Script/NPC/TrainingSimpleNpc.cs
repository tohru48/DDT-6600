// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.TrainingSimpleNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class TrainingSimpleNpc : SimpleNpcAi
  {
    public override void OnStartAttacking()
    {
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      if (this.m_targer == null)
        return;
      if (this.m_targer.Blood > 200)
        this.Beating();
      else
        this.Beat();
    }

    public void BeatCallBack()
    {
      this.Body.Beat((Living) this.m_targer, "beat", this.m_targer.Blood / 10, 0, 0, 1, 1);
    }

    private void Beat()
    {
      int demageAmount = this.m_targer.Blood / 10;
      if (this.m_targer == null || this.Body.Beat((Living) this.m_targer, "beat", demageAmount, 0, 0, 1, 1))
        return;
      int num = this.Game.Random.Next(80, 150);
      if (this.Body.X - this.m_targer.X > num)
        this.Body.MoveTo(this.Body.X - num, this.m_targer.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.BeatCallBack));
      else
        this.Body.MoveTo(this.Body.X + num, this.m_targer.Y, "walk", 1200, "", ((SimpleNpc) this.Body).NpcInfo.speed, new LivingCallBack(this.BeatCallBack));
    }
  }
}
