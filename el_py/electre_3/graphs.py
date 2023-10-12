import io
import matplotlib
import matplotlib.pyplot as plt
import networkx as nx

matplotlib.use('svg')


def create_graphs(ascending_distillation, descending_distillation, final_rank):
    # ascending_distillation = [['A1'], ['A2'], ['A3', 'A4'], ['A5', 'A6']]
    # descending_distillation = [['A1'], ['A2', 'A3'], ['A4'], ['A5'], ['A6']]
    # final_rank = []

    # creating new variables to store the `node names` of the preorder
    name_ascending_distillation = [", ".join(classes) if len(classes) > 1 else classes[0]
                                   for classes in ascending_distillation]
    name_descending_distillation = [", ".join(classes) if len(classes) > 1 else classes[0]
                                    for classes in descending_distillation]
    name_final_rank = [", ".join(classes) if len(classes) > 1 else classes[0]
                       for classes in final_rank]

    # creating the graphs
    G_ascending = nx.DiGraph()
    for i, classes in enumerate(name_ascending_distillation):
        G_ascending.add_node(classes)
        if i > 0:
            G_ascending.add_edge(name_ascending_distillation[i-1], classes)

    G_descending = nx.DiGraph()
    for i, classes in enumerate(name_descending_distillation):
        G_descending.add_node(classes)
        if i > 0:
            G_descending.add_edge(name_descending_distillation[i-1], classes)

    G_final = nx.DiGraph()
    for i, classes in enumerate(name_final_rank):
        G_final.add_node(classes)
        if i > 0:
            G_final.add_edge(name_final_rank[i-1], classes)

    return name_ascending_distillation, name_descending_distillation, name_final_rank, \
        G_ascending, G_descending, G_final


def create_image(name_ascending_distillation, name_descending_distillation, name_final_rank,
                 G_ascending, G_descending, G_final, subplot_height):
    # displaying the graphs
    fig, axs = plt.subplots(1, 3, figsize=(8, subplot_height))
    plt.subplots_adjust(
        top=0.96,
        bottom=0.01,
        left=0.01,
        right=0.99,
        wspace=0.2
    )

    # convert the node name variables in dicts
    labels_ascending = dict(zip(G_ascending.nodes(), name_ascending_distillation))
    labels_descending = dict(zip(G_descending.nodes(), name_descending_distillation))
    labels_final = dict(zip(G_final.nodes(), name_final_rank))

    # create dictionary of node positions for ascending distillation
    pos_ascending = {node: (0, -i) for i, node in enumerate(G_ascending.nodes())}
    axs[0].set_title("Ascending Distillation")
    nx.draw_networkx_nodes(G_ascending, pos=pos_ascending, node_size=2000,
                           node_shape='s', ax=axs[0], node_color='#990b23')
    nx.draw_networkx_edges(G_ascending, pos=pos_ascending, ax=axs[0])
    nx.draw_networkx_labels(G_ascending, pos=pos_ascending, labels=labels_ascending, font_size=12, ax=axs[0])

    # create dictionary of node positions for descending distillation
    pos_descending = {node: (0, -i) for i, node in enumerate(G_descending.nodes())}
    axs[1].set_title("Descending Distillation")
    nx.draw_networkx_nodes(G_descending, pos=pos_descending, node_size=2000,
                           node_shape='s', ax=axs[1], node_color='#990b23')
    nx.draw_networkx_edges(G_descending, pos=pos_descending, ax=axs[1])
    nx.draw_networkx_labels(G_descending, pos=pos_descending, labels=labels_descending, font_size=12, ax=axs[1])

    # create dictionary of node positions for final ranking
    pos_final = {node: (0, -i) for i, node in enumerate(G_final.nodes())}
    axs[2].set_title("Final Ranking")
    nx.draw_networkx_nodes(G_final, pos=pos_final, node_size=2000, node_shape='s', ax=axs[2], node_color='#990b23')
    nx.draw_networkx_edges(G_final, pos=pos_final, ax=axs[2])
    nx.draw_networkx_labels(G_final, pos=pos_final, labels=labels_final, font_size=12, ax=axs[2])

    svg_io = io.StringIO()
    plt.savefig(svg_io, format='svg')
    svg_content = svg_io.getvalue()
    svg_io.close()

    return svg_content


def run(ascending_dist, descending_dist, final_rnk):
    name_ascending_distillation, name_descending_distillation, name_final_rank, \
        G_ascending, G_descending, G_final = create_graphs(ascending_dist, descending_dist, final_rnk)

    subplot_height = 5 + 0.5 * (max(G_ascending.number_of_nodes(),
                                    G_descending.number_of_nodes(), G_final.number_of_nodes()) - 1)

    image_str = create_image(name_ascending_distillation, name_descending_distillation, name_final_rank, G_ascending,
                             G_descending, G_final, subplot_height)

    # plt.savefig('testSVG.svg', format='svg')

    return image_str


def run_el1(final_rnk):
    pass  # TODO: na pairnei to final rank me onomata kai na to kanei graph kai na to kanei plot kai meta svg inline


# debug
# if __name__ == '__main__':
#     ascending_distillation = [['A1'], ['A2'], ['A3', 'A4'], ['A5', 'A6']]
#     descending_distillation = [['A1'], ['A2', 'A3'], ['A4'], ['A5'], ['A6']]
#     final_rank = [['A1'], ['A2'], ['A3'], ['A4'], ['A5'], ['A6']]
#     run(ascending_distillation, descending_distillation, final_rank)
