// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.KhurungSimpleSecondBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class KhurungSimpleSecondBoss : ABrain
  {
    private int m_attackTurn = 0;
    private int npcID = 28007;
    private int npcID1 = 3212;
    private int isSay = 0;
    private Point[] brithPoint = new Point[5]
    {
      new Point(979, 630),
      new Point(1013, 630),
      new Point(1052, 630),
      new Point(1088, 630),
      new Point(1142, 630)
    };
    private static string[] AllAttackChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] ShootChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] KillPlayerChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] CallChat1 = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] CallChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] KillAttackChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] ShootedChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] AddBooldChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] DiedChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.isSay = 0;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1169 && allFightPlayer.X < this.Game.Map.Info.ForegroundWidth + 1)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (this.m_attackTurn == 0)
      {
        this.AllAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.SummonA();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Callvatto();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Hoimau();
        ++this.m_attackTurn;
      }
      else
      {
        this.Walk();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.KillAttackChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void Walk()
    {
      this.Game.Random.Next(670, 880);
      this.Body.ChangeDirection(this.Game.FindlivingbyDir(this.Body), 9000);
    }

    private void Dame()
    {
      this.Body.PlayMovie("beatD", 1000, 3000);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
      foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
        ;
    }

    private void PersonalAttack2()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 0.8f;
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.ShootChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.ShootChat[index], 1, 0);
      this.Game.Random.Next(670, 880);
      this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.X + 10);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 55, 1000, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatB", 1700, 0);
    }

    private void AllAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.AllAttackChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.AllAttackChat[index], 1, 0);
      this.Body.PlayMovie("beatC", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 4000, (List<Player>) null);
    }

    private void SummonA()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.AllAttackChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.AllAttackChat[index], 1, 0);
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 4000, (List<Player>) null);
    }

    public void Callvatto()
    {
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.CallChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.CallChat[index], 1, 0);
      this.Body.PlayMovie("beatB", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.Callvatto2), 2500);
    }

    private void Hoimau()
    {
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.AddBooldChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.AddBooldChat[index], 1, 0);
      this.Body.SyncAtTime = true;
      this.Body.AddBlood(5000);
      this.Body.PlayMovie("", 1000, 4500);
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.KillPlayerChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.KillPlayerChat[index], 1, 0, 2000);
    }

    public override void OnDiedSay()
    {
      int index = this.Game.Random.Next(0, KhurungSimpleSecondBoss.DiedChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.DiedChat[index], 1, 0, 1500);
    }

    public void CreateChild()
    {
    }

    public void Callvatto2()
    {
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, KhurungSimpleSecondBoss.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(KhurungSimpleSecondBoss.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, KhurungSimpleSecondBoss.DiedChat.Length);
      this.Body.Say(KhurungSimpleSecondBoss.DiedChat[index2], 1, 100, 2000);
    }
  }
}
