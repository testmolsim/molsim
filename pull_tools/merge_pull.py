#!/usr/bin/env python3

def download_auth_token(token_file):
    import requests
    import getpass
    user = input('Input GitHub username: ')
    password = getpass.getpass('Password: ')
    note = input('Input Token descripton: ')
    print(user, password)
    rq = requests.post('https://api.github.com/authorizations',
                      auth=(user, password),
                      json={"note": note})

    print(rq.json())
    token = rq.json()["token"]
    with open(token_file, 'w') as the_file:
            the_file.write(token)
    return token

def auth_token():
    import os
    auth_file = ".github_API_token"
    if os.path.isfile(auth_file):
        try:
            with open(auth_file) as f:
                return f.read()
            pass
        except IOError as e:
            print("Unable to open api token file " + auth_file)
    else:
        print("No authorization token found" + "\n" + \
              "Add it by putting it into the file: " + auth_file)
        answer = input('Shall I download the authorization file?: [y/n] ')
        if not answer or answer[0].lower() != 'y':
            print('Authorization file needed')
            exit(1)
        return download_auth_token(auth_file)

def main():
    from github import Github
    import git
    print(auth_token())
    g = Github(auth_token())
    # print(g.get_organization())
    repo = g.get_repo("testmolsim/molsim")
    local_repo = git.Repo(search_parent_directories=True)
    local_sha = local_repo.head.object.hexsha
    pull_id = 0
    for pull in repo.get_pulls():
        if(pull.head.sha == local_sha):
            to_merge = pull

    print(to_merge.title)
    # print(repo.git_url)


if __name__ == "__main__":
    main()
# r = requests.get('https://api.github.com/authorizations', auth=('thepith'))
# print(r.json())
