import os
import subprocess
import shutil

def run_test():
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    workspace = os.path.join(project_root, "tests_e2e", "sandbox", "git_test")

    # Limpar ou criar diretório
    if os.path.exists(workspace):
        shutil.rmtree(workspace)
    os.makedirs(workspace, exist_ok=True)

    shutil.copy(os.path.join(project_root, ".gitignore"), os.path.join(workspace, ".gitignore"))

    # Inicializar repositório Git
    subprocess.run(["git", "init"], cwd=workspace, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    files = [
        "keyboard.json",
        "tokenization_rules.py",
        "monkey.txt",
        "secrets.json",
        "client_secret_123.json",
        "my_key.key",
        "id_rsa.pub",
        "token.json",
        "github_token.txt"
    ]

    print("Resultados do Teste do .gitignore:")
    print("=" * 40)
    for f in files:
        res = subprocess.run(["git", "check-ignore", "-v", f], cwd=workspace, capture_output=True, text=True)
        if res.returncode == 0:
            print(f"{f:<25} : IGNORADO ({res.stdout.strip()})")
        else:
            print(f"{f:<25} : RASTREADO")

if __name__ == "__main__":
    run_test()
