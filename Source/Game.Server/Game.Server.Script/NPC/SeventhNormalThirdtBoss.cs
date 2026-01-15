// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeventhNormalThirdtBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SeventhNormalThirdtBoss : ABrain
  {
    private int m_attackTurn = 0;
    private int isSay = 0;
    private int orchinIndex = 1;
    private int currentCount = 0;
    private PhysicalObj moive;
    private int Dander = 0;
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
    private static string[] JumpChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] KillAttackChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg13"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg14")
    };
    private static string[] ShootedChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg15"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg16")
    };
    private static string[] DiedChat = new string[1]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg17")
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1269 && allFightPlayer.X < this.Game.Map.Info.ForegroundWidth + 1)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(1269, this.Game.Map.Info.ForegroundWidth + 1);
      else if (this.m_attackTurn == 0)
      {
        this.Angger2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Summon();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Angger();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Angger2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 4)
      {
        this.Summon2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 5)
      {
        this.Angger();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 6)
      {
        this.Angger2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 7)
      {
        this.Summon3();
        ++this.m_attackTurn;
      }
      else
      {
        this.Angger();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1f;
      this.Body.PlayMovie("beatB", 2000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3000, (List<Player>) null);
    }

    public void Summon()
    {
      this.Body.PlayMovie("Ato", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.PersonalAttack), 2500);
    }

    public void Summon2()
    {
      this.Body.PlayMovie("Ato", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.Seal), 2500);
    }

    public void Summon3()
    {
      this.Body.PlayMovie("Ato", 100, 0);
      this.Body.CallFuction(new LivingCallBack(this.PersonalAttackDame), 2500);
    }

    private void Seal()
    {
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.SetRelateDemagemRect(-21, -87, 72, 59);
      this.Body.RangeAttacking(this.Body.X - 1200, this.Body.X + 1200, "cry", 3000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 7000);
    }

    private void GoMovie()
    {
      Player randomPlayer1 = this.Game.FindRandomPlayer();
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer1.X, randomPlayer1.Y, "moive", "asset.game.seven.cao", "in", 1, 0);
      Player randomPlayer2 = this.Game.FindRandomPlayer();
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer2.X, randomPlayer2.Y, "moive", "asset.game.seven.cao", "in", 1, 0);
      Player randomPlayer3 = this.Game.FindRandomPlayer();
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer3.X, randomPlayer3.Y, "moive", "asset.game.seven.cao", "in", 1, 0);
      Player randomPlayer4 = this.Game.FindRandomPlayer();
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer4.X, randomPlayer4.Y, "moive", "asset.game.seven.cao", "in", 1, 0);
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.SetRelateDemagemRect(-21, -87, 72, 59);
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 0.8f;
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 84, 1200, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    public void Angger()
    {
      this.Body.State = 1;
      this.Dander += 100;
      this.Body.PlayMovie("toA", 1700, 0);
      ((TurnedLiving) this.Body).SetDander(this.Dander);
      if (this.Body.Direction == -1)
        this.Body.SetRelateDemagemRect(8, -252, 74, 50);
      else
        this.Body.SetRelateDemagemRect(-82, -252, 74, 50);
    }

    public void Angger2()
    {
      this.Body.State = 1;
      this.Dander += 100;
      this.Body.PlayMovie("standA", 1700, 0);
      ((TurnedLiving) this.Body).SetDander(this.Dander);
      if (this.Body.Direction == -1)
        this.Body.SetRelateDemagemRect(8, -252, 74, 50);
      else
        this.Body.SetRelateDemagemRect(-82, -252, 74, 50);
    }

    private void PersonalAttackDame()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.SetRelateDemagemRect(-21, -87, 72, 59);
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 0.8f;
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 84, 1200, 10000, 1, 3f, 2650))
        this.Body.PlayMovie("beat", 1700, 0);
    }
  }
}
