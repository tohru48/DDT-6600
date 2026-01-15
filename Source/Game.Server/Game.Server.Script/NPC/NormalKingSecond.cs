// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.NormalKingSecond
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
  public class NormalKingSecond : ABrain
  {
    private int m_attackTurn = 0;
    private int m_turn = 0;
    private PhysicalObj m_wallLeft = (PhysicalObj) null;
    private PhysicalObj m_wallRight = (PhysicalObj) null;
    private int IsEixt = 0;
    private int npcID = 1110;
    private static string[] AllAttackChat = new string[3]
    {
      "要地震喽！！<br/>各位请扶好哦",
      "把你武器震下来！",
      "看你们能还经得起几下！！"
    };
    private static string[] ShootChat = new string[3]
    {
      "让你知道什么叫百发百中！",
      "送你一个球~你可要接好啦",
      "你们这群无知的低等庶民"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
      "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"
    };
    private static string[] KillPlayerChat = new string[3]
    {
      "马迪亚斯不要再控制我！",
      "这就是挑战我的下场！",
      "不！！这不是我的意愿… "
    };
    private static string[] AddBooldChat = new string[3]
    {
      "扭啊扭~<br/>扭啊扭~~",
      "哈利路亚~<br/>路亚路亚~~",
      "呀呀呀，<br/>好舒服啊！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "君临天下！！"
    };
    private static string[] FrostChat = new string[3]
    {
      "来尝尝这个吧",
      "让你冷静一下",
      "你们激怒了我"
    };
    private static string[] WallChat = new string[2]
    {
      "神啊，赐予我力量吧！",
      "绝望吧，看我的水晶防护墙！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 390 && allFightPlayer.X < 1110)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(390, 1110);
      else if (this.m_attackTurn == 0)
      {
        this.AllAttack();
        if (this.IsEixt == 1)
        {
          this.m_wallLeft.CanPenetrate = true;
          this.m_wallRight.CanPenetrate = true;
          this.Game.RemovePhysicalObj(this.m_wallLeft, true);
          this.Game.RemovePhysicalObj(this.m_wallRight, true);
          this.IsEixt = 0;
        }
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.FrostAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.ProtectingWall();
        ++this.m_attackTurn;
      }
      else
      {
        this.CriticalStrikes();
        this.m_attackTurn = 0;
      }
    }

    private void CriticalStrikes()
    {
      this.Game.GetFrostPlayerRadom();
      List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
      List<Player> players = new List<Player>();
      foreach (Player player in allFightPlayers)
      {
        if (!player.IsFrost)
          players.Add(player);
      }
      this.Body.CurrentDamagePlus = 30f;
      if (players.Count != allFightPlayers.Count)
      {
        if (players.Count != 0)
        {
          this.Body.PlayMovie("beat1", 0, 0);
          this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "beat1", 1500, players);
        }
        else
        {
          this.Body.PlayMovie("beat1", 0, 0);
          this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "beat1", 1500, (List<Player>) null);
        }
      }
      else
      {
        this.Body.Say("小的们给我上，好好教训敌人！", 1, 3300);
        this.Body.PlayMovie("renew", 3500, 0);
        this.Body.CallFuction(new LivingCallBack(this.CreateChild), 6000);
      }
    }

    private void FrostAttack()
    {
      this.Body.MoveTo(this.Game.Random.Next(850, 920), this.Body.Y, "walk", 0, "", ((SimpleBoss) this.Body).NpcInfo.speed, new LivingCallBack(this.NextAttack));
    }

    private void AllAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      if (this.m_turn == 0)
      {
        int index = this.Game.Random.Next(0, NormalKingSecond.AllAttackChat.Length);
        this.Body.Say(NormalKingSecond.AllAttackChat[index], 1, 13000);
        this.Body.PlayMovie("beat1", 15000, 0);
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 17000, (List<Player>) null);
        ++this.m_turn;
      }
      else
      {
        int index = this.Game.Random.Next(0, NormalKingSecond.AllAttackChat.Length);
        this.Body.Say(NormalKingSecond.AllAttackChat[index], 1, 0);
        this.Body.PlayMovie("beat1", 1000, 0);
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
      }
    }

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, NormalKingSecond.KillAttackChat.Length);
      if (this.m_turn == 0)
      {
        this.Body.CurrentDamagePlus = 10f;
        this.Body.Say(NormalKingSecond.KillAttackChat[index], 1, 13000);
        this.Body.PlayMovie("beat1", 15000, 0);
        this.Body.RangeAttacking(fx, tx, "cry", 17000, (List<Player>) null);
        ++this.m_turn;
      }
      else
      {
        this.Body.CurrentDamagePlus = 10f;
        this.Body.Say(NormalKingSecond.KillAttackChat[index], 1, 0);
        this.Body.PlayMovie("beat1", 2000, 0);
        this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
      }
    }

    private void ProtectingWall()
    {
      if (this.IsEixt == 0)
      {
        this.m_wallLeft = ((PVEGame) this.Game).CreatePhysicalObj(this.Body.X - 65, 620, "wallLeft", "com.mapobject.asset.WaveAsset_01_left", "1", 1, 0);
        this.m_wallRight = ((PVEGame) this.Game).CreatePhysicalObj(this.Body.X + 65, 620, "wallLeft", "com.mapobject.asset.WaveAsset_01_right", "1", 1, 0);
        this.m_wallLeft.SetRect(-165, -169, 43, 330);
        this.m_wallRight.SetRect(128, -165, 41, 330);
        this.IsEixt = 1;
      }
      int index = this.Game.Random.Next(0, NormalKingSecond.WallChat.Length);
      this.Body.Say(NormalKingSecond.WallChat[index], 1, 0);
    }

    public void CreateChild()
    {
      this.Body.PlayMovie("renew", 100, 2000);
      ((SimpleBoss) this.Body).CreateChild(this.npcID, 520, 530, 400, 6, 1);
    }

    private void NextAttack()
    {
      int num = this.Game.Random.Next(1, 2);
      for (int index1 = 0; index1 < num; ++index1)
      {
        Player randomPlayer = this.Game.FindRandomPlayer();
        int index2 = this.Game.Random.Next(0, NormalKingSecond.ShootChat.Length);
        this.Body.Say(NormalKingSecond.ShootChat[index2], 1, 0);
        if (randomPlayer.X > this.Body.X)
          this.Body.ChangeDirection(1, 500);
        else
          this.Body.ChangeDirection(-1, 500);
        if (randomPlayer != null && !randomPlayer.IsFrost && this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, ((SimpleBoss) this.Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1.5f, 2000))
          this.Body.PlayMovie("beat2", 1500, 0);
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
