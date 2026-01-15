// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdSimpleBloomNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdSimpleBloomNpc : ABrain
  {
    private Player m_target = (Player) null;
    private int m_maxBlood;
    private int m_blood;
    private int living;
    private int m_team;
    private int Team;
    private int m_targetDis = 0;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.m_target = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      this.m_maxBlood = 49999;
      this.m_blood = 40000;
      this.Body.Say(LanguageMgr.GetTranslation("Hồi máu cho tôi, tôi sẻ dẫn các cậu ra khỏi đây !"), 0, 200, 0);
      if (this.m_blood > this.m_maxBlood)
      {
        this.m_blood = this.m_maxBlood;
        this.Body.PlayMovie("grow", 100, 0);
        this.Body.Die(1000);
      }
      else
        this.Beat();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void MoveToPlayer(Player player)
    {
      int num = this.Game.Random.Next(((SimpleNpc) this.Body).NpcInfo.MoveMin, ((SimpleNpc) this.Body).NpcInfo.MoveMax);
      if (player.X > this.Body.X)
        this.Body.MoveTo(this.Body.X + num, this.Body.Y, "walk", 2000, "", 3, new LivingCallBack(this.Beat));
      else
        this.Body.MoveTo(this.Body.X - num, this.Body.Y, "walk", 2000, "", 3, new LivingCallBack(this.Beat));
    }

    public void Beat()
    {
    }
  }
}
