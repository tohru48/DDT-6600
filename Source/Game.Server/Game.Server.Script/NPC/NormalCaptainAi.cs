// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.NormalCaptainAi
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class NormalCaptainAi : ABrain
  {
    private int m_attackTurn = 0;
    private List<SimpleNpc> Children = new List<SimpleNpc>();
    private int npcID = 1109;
    private static string[] AllAttackChat = new string[3]
    {
      "你们这是自寻死路！",
      "你惹毛我了!",
      "超级无敌大地震……<br/>震……震…… "
    };
    private static string[] ShootChat = new string[2]
    {
      "砸你家玻璃。",
      "看哥打的可比你们准多了"
    };
    private static string[] KillPlayerChat = new string[2]
    {
      "送你回老家！",
      "就凭你还妄想能够打败我？"
    };
    private static string[] CallChat = new string[2]
    {
      "卫兵！ <br/>卫兵！！ ",
      "啵咕们！！<br/>给我些帮助！"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呦！很痛…",
      "我还顶的住…"
    };
    private static string[] JumpChat = new string[3]
    {
      "为了你们的胜利，<br/>向我开炮！",
      "你再往前半步我就把你给杀了！",
      "高！<br/>实在是高！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "超级肉弹！！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.Body.SetRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
      if (this.Body.Direction == -1)
        this.Body.SetRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
      else
        this.Body.SetRect(-((SimpleBoss) this.Body).NpcInfo.X - ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 480 && allFightPlayer.X < 1000)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(480, 1000);
      else if (this.m_attackTurn == 0)
      {
        this.AllAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.PersonalAttack();
        ++this.m_attackTurn;
      }
      else
      {
        this.Summon();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.ChangeDirection(3);
      int index = this.Game.Random.Next(0, NormalCaptainAi.KillAttackChat.Length);
      this.Body.Say(NormalCaptainAi.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beat2", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void AllAttack()
    {
      this.ChangeDirection(3);
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, NormalCaptainAi.AllAttackChat.Length);
      this.Body.Say(NormalCaptainAi.AllAttackChat[index], 1, 0);
      this.Body.FallFrom(this.Body.X, 509, (string) null, 1000, 1, 12);
      this.Body.PlayMovie("beat2", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 4000, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      this.ChangeDirection(3);
      int index = this.Game.Random.Next(0, NormalCaptainAi.ShootChat.Length);
      this.Body.Say(NormalCaptainAi.ShootChat[index], 1, 0);
      int x = this.Game.Random.Next(670, 880);
      int direction = this.Body.Direction;
      this.Body.MoveTo(x, this.Body.Y, "walk", 1000, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.NextAttack));
      this.Body.ChangeDirection(this.Game.FindlivingbyDir(this.Body), 9000);
    }

    private void Summon()
    {
      this.ChangeDirection(3);
      this.Body.JumpTo(this.Body.X, this.Body.Y - 300, "Jump", 1000, 1);
      int index = this.Game.Random.Next(0, NormalCaptainAi.CallChat.Length);
      this.Body.Say(NormalCaptainAi.CallChat[index], 1, 3300);
      this.Body.PlayMovie("call", 3500, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 4000);
    }

    private void NextAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.SetRect(0, 0, 0, 0);
      if (randomPlayer.X > this.Body.Y)
        this.Body.ChangeDirection(1, 500);
      else
        this.Body.ChangeDirection(-1, 500);
      this.Body.CurrentDamagePlus = 0.8f;
      if (randomPlayer == null)
        return;
      int x = this.Game.Random.Next(randomPlayer.X - 50, randomPlayer.X + 50);
      if (this.Body.ShootPoint(x, randomPlayer.Y, ((SimpleBoss) this.Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1f, 2200))
        this.Body.PlayMovie("beat", 1700, 0);
      if (this.Body.ShootPoint(x, randomPlayer.Y, ((SimpleBoss) this.Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1f, 3200))
        this.Body.PlayMovie("beat", 2700, 0);
    }

    private void ChangeDirection(int count)
    {
      int direction = this.Body.Direction;
      for (int index = 0; index < count; ++index)
      {
        this.Body.ChangeDirection(-direction, index * 200 + 100);
        this.Body.ChangeDirection(direction, (index + 1) * 100 + index * 200);
      }
    }

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID, 520, 530, 430, 6, 1);
    }
  }
}
