// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeventhNormalHouseAi
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SeventhNormalHouseAi : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj moive;
    private List<SimpleNpc> Children = new List<SimpleNpc>();
    private int npcID2 = 7122;
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
        if (allFightPlayer.IsLiving && allFightPlayer.X < 650)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 650);
      else if (this.m_attackTurn == 0)
      {
        this.Summon();
        ++this.m_attackTurn;
      }
      else
        this.m_attackTurn = 0;
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, SeventhNormalHouseAi.KillAttackChat.Length);
      this.Body.Say(SeventhNormalHouseAi.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 4000);
    }

    private void GoMovie()
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X < 700)
          this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allFightPlayer.X, allFightPlayer.Y, "moive", "asset.game.seven.jinquhd", "out", 1, 0);
      }
    }

    private void Summon() => this.Body.CallFuction(new LivingCallBack(this.CreateChild), 4000);

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID2, 880, 900, 20, 6, 1);
    }
  }
}
