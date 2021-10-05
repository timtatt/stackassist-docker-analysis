import csv
from os.path import dirname, realpath

def get_posts_from_export(file_name):
    with open(f'{dirname(realpath(__file__))}/{file_name}') as dataset_file:
        return dict({row['Id']: row for row in csv.DictReader(dataset_file)})
        

if __name__ == '__main__':
    posts_best_answers = get_posts_from_export('datasets/posts-best-answer.csv')
    posts_highest_score = get_posts_from_export('datasets/posts-highest-score.csv')
    posts_most_children = get_posts_from_export('datasets/posts-most-children.csv')
    posts_most_views = get_posts_from_export('datasets/posts-most-views.csv')

    # Leaving posts_best_answers out for the time being (didn't intersect with any other datasets)
    common_post_ids = set(posts_most_children.keys())
    for dataset in [posts_highest_score, posts_most_views]:
        common_post_ids.intersection_update(set(dataset.keys()))
    
    common_posts = list(map(lambda post_id: posts_most_children[post_id], common_post_ids))

    with open('common-posts.csv', 'w+') as common_posts_file:
        writer = csv.DictWriter(common_posts_file, fieldnames=common_posts[0].keys())
        writer.writeheader()
        writer.writerows(common_posts)