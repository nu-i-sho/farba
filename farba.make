cd /root/Development/farba

ocamlc -o farba.run PARSABLE.ml CHAR_PARSABLE.ml ORDERABLE.ml OPPOSABLE.ml ORDERABLE_AND_OPPOSABLE.ml hand.mli hand.ml DIRECTION_SEED.ml DIRECTION.ml EMPTIBLE.ml EMPTIBLE_AND_CHAR_PARSABLE.ml READONLY_LINK.ml MAKEABLE_READONLY_LINK.ml LINK.ml INTEROPPOSITION_LINK.ml DLINK.ml link.mli link.ml interoppositionLink.mli interoppositionLink.ml dlink.mli dlink.ml ROUNDELAY_LINK.ml roundelayLink.mli roundelayLink.ml color.mli color.ml cell.mli cell.ml direction.mli direction.ml fill.mli fill.ml handDirection.mli handDirection.ml UpDownLeftRight.ml squareDirectionSeed.mli squareDirectionSeed.ml squareDirection.mli squareDirection.ml hexagonDirection.mli hexagonDirection.ml place.mli place.ml command.mli command.ml FARBA.ml PARSABLE_FARBA.ml farba.mli farba.ml squareFarba.mli squareFarba.ml

echo "build complete"
